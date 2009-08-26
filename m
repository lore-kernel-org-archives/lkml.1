Return-Path: <linux-kernel-owner+w=401wt.eu-S933002AbZHZNV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002AbZHZNV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 09:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932964AbZHZNVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 09:21:55 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:25055 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932919AbZHZNVz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 09:21:55 -0400
X-Greylist: delayed 2735 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Aug 2009 09:21:54 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: SoftDog: reboot message missed
Date: Wed, 26 Aug 2009 08:34:44 -0400
Message-ID: <FC88FED2F4C8574C9318C4D6CDA2BFA8BCEB03@CORPUSMX90A.corp.emc.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: SoftDog: reboot message missed
Thread-Index: AcomSZcuMsARakAsTfC0OYeF4Bu1kw==
From: <Timofeev_Alexander@emc.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 26 Aug 2009 12:36:15.0393 (UTC) FILETIME=[CD658110:01CA2649]
X-EMM-EM: Active
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I use 2.6.16.60 kernel. It's been compiled with CONFIG_WATCHDOG_NOWAYOUT
<http://lxr.linux.no/linux-bk+*/+code=CONFIG_WATCHDOG_NOWAYOUT> =false.
It reboots system silently. The reboot message does not appear in
/var/log/messages.
Syslog-ng config is correct.
I looked through the watchdog.c and found:

  93
<http://lxr.linux.no/linux-bk+*/drivers/char/watchdog/softdog.c#L93>
static void watchdog_fire
<http://lxr.linux.no/linux-bk+*/+code=watchdog_fire> (unsigned long data
<http://lxr.linux.no/linux-bk+*/+code=data> )
  94
<http://lxr.linux.no/linux-bk+*/drivers/char/watchdog/softdog.c#L94> {
  95
<http://lxr.linux.no/linux-bk+*/drivers/char/watchdog/softdog.c#L95>
if (soft_noboot <http://lxr.linux.no/linux-bk+*/+code=soft_noboot> )
  96
<http://lxr.linux.no/linux-bk+*/drivers/char/watchdog/softdog.c#L96>
printk <http://lxr.linux.no/linux-bk+*/+code=printk> (KERN_CRIT
<http://lxr.linux.no/linux-bk+*/+code=KERN_CRIT>  PFX
<http://lxr.linux.no/linux-bk+*/+code=PFX>  "Triggered - Reboot
ignored.\n");
  97
<http://lxr.linux.no/linux-bk+*/drivers/char/watchdog/softdog.c#L97>
else
  98
<http://lxr.linux.no/linux-bk+*/drivers/char/watchdog/softdog.c#L98>
{
  99
<http://lxr.linux.no/linux-bk+*/drivers/char/watchdog/softdog.c#L99>
printk <http://lxr.linux.no/linux-bk+*/+code=printk> (KERN_CRIT
<http://lxr.linux.no/linux-bk+*/+code=KERN_CRIT>  PFX
<http://lxr.linux.no/linux-bk+*/+code=PFX>  "Initiating system
reboot.\n");
 100
<http://lxr.linux.no/linux-bk+*/drivers/char/watchdog/softdog.c#L100>
machine_restart <http://lxr.linux.no/linux-bk+*/+code=machine_restart>
(NULL <http://lxr.linux.no/linux-bk+*/+code=NULL> );
 101
<http://lxr.linux.no/linux-bk+*/drivers/char/watchdog/softdog.c#L101>
printk <http://lxr.linux.no/linux-bk+*/+code=printk> (KERN_CRIT
<http://lxr.linux.no/linux-bk+*/+code=KERN_CRIT>  PFX
<http://lxr.linux.no/linux-bk+*/+code=PFX>  "Reboot didn't ?????\n");
 102
<http://lxr.linux.no/linux-bk+*/drivers/char/watchdog/softdog.c#L102>
}
 103
<http://lxr.linux.no/linux-bk+*/drivers/char/watchdog/softdog.c#L103> }


I suspect that system might be halted before printk buffer gets flushed.
Does anybody encounter such a behavior? Is there a workaround?

In fact I only need to know if the last reboot was caused by the timer.
Unfortunately the WDIOC_GETBOOTSTATUS
<http://lxr.linux.no/linux-bk+*/+code=WDIOC_GETBOOTSTATUS>  ioctl is not
implemented ( according to the watchdog.c:softdog_ioctl
<http://lxr.linux.no/linux-bk+*/+code=softdog_ioctl>  ).

 210
<http://lxr.linux.no/linux-bk+*/drivers/char/watchdog/softdog.c#L210>
case WDIOC_GETBOOTSTATUS
<http://lxr.linux.no/linux-bk+*/+code=WDIOC_GETBOOTSTATUS> :
 211
<http://lxr.linux.no/linux-bk+*/drivers/char/watchdog/softdog.c#L211>
return put_user <http://lxr.linux.no/linux-bk+*/+code=put_user> (0, p
<http://lxr.linux.no/linux-bk+*/+code=p> );


TIA


Alex T.




