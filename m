Return-Path: <linux-kernel-owner+w=401wt.eu-S932106AbZJBRog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106AbZJBRog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 13:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932075AbZJBRof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 13:44:35 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:36540 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757801AbZJBRoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 13:44:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=GyfPMugM3I8+qGEhCD8SWy3By9715ZQ1yiK9BTgbgyZ539n/E7YOnqWMcWvV08zGdy
         Gxb8Bs7T6vURp/C3xcCb77m4c9VT78mukTp1OqC/t+urGn+MJKcQ4X3HvUtcFst9Q3JV
         fyaemCqsc4zoOzTdXmzErLvPiS2IlCbXitmi8=
MIME-Version: 1.0
Date: Fri, 2 Oct 2009 13:44:37 -0400
X-Google-Sender-Auth: 0577e9f37fe2e39d
Message-ID: <cb0375e10910021044n182d696dy8fd566925e46b134@mail.gmail.com>
Subject: High power consumption after suspend/resume cycle
From: Andrew Lutomirski <luto@mit.edu>
To: linux-kernel@vger.kernel.org, linux-thinkpad@linux-thinkpad.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all-

I'm running a git kernel that's slightly newer than 2.6.32-rc1.

First, thanks for all the great work everywhere on laptop power
consumption -- on my Lenovo X200s, it looks like Linux is getting
close to Windows (Windows wins by about 0.7W, except that its power
usage frequently spikes since Windows apparently still doesn't know
how to sit still and do nothing, whereas Linux's seems more stable.).
Windows after a reboot, even running KDE with compositing enabled and
while connected to wifi, at least after some tweaking.

There's a catch, though: after a suspend/resume cycle, power
consumption goes up by over well over a watt.  (On a system that draws
about 7 watts before suspending, that's a big deal.)  I've tried
turning off X, suspending with 'echo mem > /sys/power/state' to avoid
any distro scripts running, and manually restoring SATA power saving
settings, but it still happens.  I even tried unbinding e1000e and
both USB drivers, unloading the i2400 (wimax) driver, iwlagn, and
iwlcore, and it still happens.  This is 100% reproducible, and I'd be
happy to test things.

This could be a BIOS bug I suppose (although I'm running the latest
BIOS), but Windows 7 does not have this problem at all.

Any ideas about what to try or what subsystem to blame?

I'm running Fedora 11 if that makes any difference.

Thanks,
Andy
