Return-Path: <linux-kernel-owner+w=401wt.eu-S1758383AbXIZNTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383AbXIZNTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 09:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbXIZNS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 09:18:56 -0400
Received: from spirit.analogic.com ([204.178.40.4]:2205 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbXIZNSz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 09:18:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 26 Sep 2007 13:17:19.0969 (UTC) FILETIME=[913CF510:01C8003F]
Content-class: urn:content-classes:message
Subject: Re: Chroot bug
Date: Wed, 26 Sep 2007 09:18:04 -0400
Message-ID: <Pine.LNX.4.61.0709260906080.31286@chaos.analogic.com>
In-Reply-To: <46FA3EE8.4080707@davidnewall.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Chroot bug
Thread-Index: AcgAP5FGJCIZ0PkrQQCq+4rL0WCYvQ==
References: <20070925114947.GA9721@vino.hallyn.com> <46F91417.9050600@davidnewall.com> <46F924E3.50205@davidnewall.com> <20070925163040.12a3c2f8@the-village.bc.nu> <46F92AAB.1060903@davidnewall.com> <20070925164806.4cadc6a5@the-village.bc.nu> <46F99EDE.70905@davidnewall.com> <20070926005551.GS6800@stusta.de> <F23AFB4D-E989-4F06-A256-4D12D852DFA2@mac.com> <46FA341A.80706@davidnewall.com> <20070926104500.GA4354@dspnet.fr.eu.org> <46FA3EE8.4080707@davidnewall.com>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "David Newall" <david@davidnewall.com>
Cc: "Olivier Galibert" <galibert@pobox.com>,
       "Kyle Moffett" <mrmacman_g4@mac.com>, "Adrian Bunk" <bunk@kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Serge E. Hallyn" <serge@hallyn.com>,
       "Bill Davidsen" <davidsen@tmr.com>,
       "Philipp Marek" <philipp@marek.priv.at>, <7eggert@gmx.de>,
       "majkls" <majkls@prepere.com>, <bunk@fs.tum.de>,
       <linux-kernel@vger.kernel.org>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 26 Sep 2007, David Newall wrote:

> Olivier Galibert wrote:
>> chroot does not allow you to walk out if you're in.
>
> You're mistaken.  Or more properly, further use of chroot lets you walk
> out.  This really has been said before, and before, and before.
>
>    chroot("subtree");   // enter chroot
>    chdir("/");    // now at subtree
>    chroot("/tmp");   // now outside of chroot
>
>
> BSD redefined chroot so that the working directory is set to the new
> root on subsequent uses of chroot; that's how they solved the bug.

I don't know that the so-called requirements are, but if you
have a distribution tree mounted on /mnt and you perform the
following operations:

cd /mnt
chroot . bin/bash

That shell, will not leave the new root until it exits or
executes `chroot`. I've tried the "tricks" about mounting
/proc and changing to 'cwd' of init, etc. However, your
new root needs to NOT have the chroot utility available
and/or the system call needs to be removed or trapped
in the runtime library of the new root, because, quite
obviously, a root process can do anything it wants.
That's how Unix was designed. So, if you don't want
somebody to get out of your 'jail' don't provide
the keys. It's clearly not a kernel issue.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
