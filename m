Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbZD2Jeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbZD2Jeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZD2Jee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:34:34 -0400
Received: from web32605.mail.mud.yahoo.com ([68.142.207.232]:33419 "HELO
	web32605.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752751AbZD2Jed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:34:33 -0400
Message-ID: <96590.701.qm@web32605.mail.mud.yahoo.com>
X-YMail-OSG: l9E37B4VM1lWtiDiVyCeLKi_BG8MlGuRd8Ui1uz8CBfjAYCOh7W4y0XD7HC5xGqVTh82twg7w8VFo0rK.NRUIjNWaYc1INq7hkWLtJdEp3biWa4XJ38Vv679eWBvqzKKEZYHB50NXJjAh.6FSnTtpCmpZXM3XycLMI5Vaczi_1hCAx46ITPbSSe4gITRGXvALsqTfBRW5N.57ZzRq5mIOtYHgFff3SpZlQ0BmTkqoG01CTfK8D2rwe_SUro86j7zt.ukiEPGrJz8vzQ5koUXMh2oPp4uuHkNbBTeAtVmCNsuksoN5L6N
X-RocketYMMF: knobi.rm
X-Mailer: YahooMailRC/1277.35 YahooMailWebService/0.7.289.1
References: <409142.83316.qm@web32605.mail.mud.yahoo.com> <20090428182837.62c51f26.akpm@linux-foundation.org>
Date: Wed, 29 Apr 2009 02:34:32 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       efault@gmx.de, tigran aivazian <tigran@aivazian.fsnet.co.uk>
In-Reply-To: <20090428182837.62c51f26.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- Original Message ----

> From: Andrew Morton <akpm@linux-foundation.org>
> To: Martin Knoblauch <knobi@knobisoft.de>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>; linux-kernel@vger.kernel.org; efault@gmx.de; tigran aivazian <tigran@aivazian.fsnet.co.uk>
> Sent: Wednesday, April 29, 2009 3:28:37 AM
> Subject: Re: Analyzed/Solved: Booting 2.6.30-rc2-git7 very slow
> 
> On Fri, 24 Apr 2009 05:45:19 -0700 (PDT) Martin Knoblauch 
> wrote:
> 
> > 
> > 
> >  OK, I just found the reason for both intel-ucode and tg3 failures. Apparently 
> between 2.6.28 and 2.6.29 the mount of sysfs has subtely changed from:
> > 
> > /sys /sys sysfs rw 0 0
> > 
> > to:
> > 
> > none /sys sysfs rw,relatime 0 0
> 
> I assume that you're referring to the contents of /proc/mounts?
> 
> >  The "none" breaks the RHEL-4 provided hotplug script "firmware.agent" when it 
> tries to parse the mount point for "/sys". As a result, the firmware loading is 
> never properly finished and the driver(s) just timeout on the value  in 
> /sys/class/firmware/timeout. Bingo. Simple fix in user-pace possible - cool down 
> Martin :-)
> > 
> > Questions remains: was this intentional? It breaks existing userspace and 
> should therefore be considered a regression - right? On the other hand, it will 
> never be a problem for RHEL-4/5 kernels, unless the change in 2.6.29 gets 
> backported. Any ideas?
> 
> afaik that was unintentional and was probably a mistake.
> 
> I wonder how we did that.

 Actually, what breaks the RHEL-4.3 script is not the "none", but the duplicate lines in /proc/mounts that I reported earlier in the "regression" thread.

[root@lpsdm52]# grep sysfs /proc/mounts
none /sys sysfs rw,relatime 0 0
/sys /sys sysfs rw,relatime 0 0

 One of them likely comes from the respective line in /etc/fstab, but where does the second one come from?


Cheers
Martin

