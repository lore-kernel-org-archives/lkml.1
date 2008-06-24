Return-Path: <linux-kernel-owner+w=401wt.eu-S1758214AbYFXIJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbYFXIJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 04:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757924AbYFXIIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 04:08:54 -0400
Received: from nebensachen.de ([195.34.83.29]:44995 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757821AbYFXIIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 04:08:50 -0400
X-Hashcash: 1:20:080624:hmh@hmh.eng.br::pqGffiFEqfU026XQ:0000l8w
X-Hashcash: 1:20:080624:pavel@suse.cz::XzJGQwHSORPlJ4lz:00000kiM
X-Hashcash: 1:20:080624:mrmacman_g4@mac.com::5Ucem6YPqbE7eAUi:0000000000000000000000000000000000000000005lMN
X-Hashcash: 1:20:080624:rjw@sisk.pl::SEilBFIIiG89RH5b:00000000rH
X-Hashcash: 1:20:080624:mjg59@srcf.ucam.org::CogQGfSfUSfwk1EP:00000000000000000000000000000000000000000056B9
X-Hashcash: 1:20:080624:dgc@sgi.com::mzSwsm0SX5fA6egE:0000006/kq
X-Hashcash: 1:20:080624:jeremy@goop.org::djXEXIfIXJfVn8y8:00Hkpl
X-Hashcash: 1:20:080624:xfs-masters@oss.sgi.com::R0F3rC1WeCn0WZf9:000000000000000000000000000000000000002i8u
X-Hashcash: 1:20:080624:linux-kernel@vger.kernel.org::Wl7eW7MAEwMHkBvX:000000000000000000000000000000000Du8r
From: Elias Oltmanns <eo@nebensachen.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Pavel Machek <pavel@suse.cz>, Kyle Moffett <mrmacman_g4@mac.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, David Chinner <dgc@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, xfs-masters@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: freeze vs freezer
References: <4744FD87.7010301@goop.org> <200711262253.35420.rjw@sisk.pl>
	<20071127053846.GA28884@srcf.ucam.org>
	<200711271840.24825.rjw@sisk.pl>
	<8B00F353-983F-40E7-931B-EA73CCD32F0A@mac.com>
	<20080623071601.GA1553@elf.ucw.cz>
	<20080623140012.GA11899@khazad-dum.debian.net>
Date: Tue, 24 Jun 2008 10:08:17 +0200
In-Reply-To: <20080623140012.GA11899@khazad-dum.debian.net> (Henrique de
	Moraes Holschuh's message of "Mon, 23 Jun 2008 11:00:12 -0300")
Message-ID: <87od5rs1am.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> On Mon, 23 Jun 2008, Pavel Machek wrote:
>> (replying to *very* old mail).
>
>> 
>> >>>> We wait until they can continue.
>> >>>
>> >>> So if I have a process blocked on an unavilable NFS mount, I can't
>> >>> suspend?
>> >>
>> >> That's correct, you can't.
>> >>
>> >> [And I know what you're going to say. ;-)]
>> >
>> > Why exactly does suspend/hibernation depend on "TASK_INTERRUPTIBLE" instead 
>> > of a zero preempt_count()?  Really what we should do is just iterate over 
>> > all of the actual physical devices and tell each one "Block new IO requests 
>> > preemptably, finish pending DMA, put the hardware in low-power mode, and 
>> > prepare for suspend/hibernate".  As long as each driver knows how to do 
>> > those simple things we can have an entirely consistent kernel image for 
>> > both suspend and for hibernation.
>> 
>> Patch would be welcome, actually. It turns out blocking new
>> IO-requests is not completely trivial.

Quite. But I'm not sure I see what this is all about yet. From the IDE
and SCSI subsystems I remember that they block all I/O from higher levels
once the suspend callbacks have been executed. I haven't made an effort
to understand the freezer (or indeed anything related to hibernation)
yet since I don't even use hibernation myself (only s2ram). Do you have
any suggestion where to start reading up on things so I can get an idea
what the issues are and what you would like IDE / SCSI / ... to do?

>
> Is this the same thing the per-device IO-queue-freeze patches for
>HDAPS also
> need to do?  If so, you may want to talk to Elias Oltmanns
> <eo@nebensachen.de> about it.  Added to CC.

Thanks for the heads up Henrique. Even though these issues seem to be
related up to a certain degree, there probably are some important
differences. When suspending a system, the emphasis is on leaving the
system in a consistent state (think of journalled file systems), whereas
disk shock protection is mainly concerned with stopping I/O as soon as
possible. As yet, I cannot possibly say to what extend these two
concepts can be reconciled in the sense of sharing some common code.

Regards,

Elias
