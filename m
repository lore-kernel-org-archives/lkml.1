Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699AbYI1MOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbYI1MOT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 08:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbYI1MOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 08:14:12 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:61637 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbYI1MOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 08:14:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MQcfgxm4dAN1uoMHCVrrKZr6rum6gfuSEPs6u/TNH6ubUx3RK+57dayYwPJxjM1vnv
         2rWaaYDFXEYL7/kZAmhP4yJxUX10aQnhnbPnrBC4QdccWyGFgeGrsB8v5uceT2hmgD+j
         QnMLaHs/XcCGpAseSG82c9Lt8bc5BzIw0mc00=
Message-ID: <19f34abd0809280514o70787d36ua03c44945dc9f6ee@mail.gmail.com>
Date: Sun, 28 Sep 2008 14:14:09 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Jay Cliburn" <jacliburn@bellsouth.net>
Subject: Re: Console not capturing call trace
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080921104625.655f55df@osprey.hogchain.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080921104625.655f55df@osprey.hogchain.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2008 at 5:46 PM, Jay Cliburn <jacliburn@bellsouth.net> wrote:
> I'm thinking this may be a userspace issue, but most users don't hack
> network drivers and don't encounter kernel warnings and oopses, and
> therefore aren't likely to encounter this, so I'm bringing it to the
> kernel list (especially those who run Fedora) for assistance/opinions.
>
> The problem:  I no longer get full module lists and call traces on the
> console for a WARN_ON (for example).  I run Fedora 9 and its current
> version of rsyslog-3.18.1-2.fc9.x86_64.  Reverting to
> rsyslog-3.14.1-2.fc9.x86_64 or advancing to
> rsyslog-3.21.3-3.fc10.x86_64 didn't seem to help.
>
> For test purposes I inserted a WARN_ON(1) statement in the atl1 driver,
> and dmesg shows the output just fine, but /var/log/messages and my
> serial console both fail to show the module list and call trace.
> (Evidence below.)
>
> One thing I can't figure out is where the "<8>" comes from in
> the serial console output down at the bottom of this message.
> Backstepping from warn_on_slowpath() to print_modules() in the kernel
> code doesn't seem to show an <8> printed anywhere.  I've got
> /proc/sys/kernel/printk set to 8 8 8 8, so maybe that's related?
>
> Has anyone else encountered this or know which rsyslogd knob to tweak
> to enable the full modules list and call trace?  I've verified the
> condition occurs with current git, 2.6.26.3, and 2.6.25.16 kernels, so I
> think it's not a kernel problem.  It *used* to work fine, but I can't
> remember when it stopped doing so.

Hi,

I'll try an answer since you've had no other replies.

You probably need to set up rsyslogd to log all kernel messages. For
me, changing the /etc/rsyslog.conf like this does the trick (but
beware of my linewrapping client):

--- rsyslog.conf.orig   2008-09-28 14:10:20.000000000 +0200
+++ rsyslog.conf.new    2008-09-28 14:10:12.000000000 +0200
@@ -36,7 +36,7 @@

 # Log anything (except mail) of level info or higher.
 # Don't log private authentication messages!
-*.info;mail.none;authpriv.none;cron.none                /var/log/messages
+kern.*;*.info;mail.none;authpriv.none;cron.none
/var/log/messages

 # The authpriv file has restricted access.
 authpriv.*                                              /var/log/secure


I.e., you just need to add "kern.*" in the line that controls logging
to /var/log/messages. I hope this helps.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
