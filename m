Return-Path: <linux-kernel-owner+w=401wt.eu-S1757467AbXJ2JAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbXJ2JAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 05:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbXJ2I7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 04:59:53 -0400
Received: from anyanka.rfc1149.net ([81.56.47.149]:57366 "EHLO
	mail2.rfc1149.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbXJ2I7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 04:59:52 -0400
To: "marco gaddoni" <marco.gaddoni@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at mm/slab.c:597!
References: <3b2bc9d0710290050g4e1cf8aoa7917ab7e091da5a@mail.gmail.com>
In-Reply-To: <3b2bc9d0710290050g4e1cf8aoa7917ab7e091da5a@mail.gmail.com>
Date: Mon, 29 Oct 2007 09:59:49 +0100
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: Samuel Tardieu <sam@rfc1149.net>
Organization: RFC 1149 (see http://www.rfc1149.net/)
Content-Transfer-Encoding: 8bit
X-WWW: http://www.rfc1149.net/sam
X-Jabber: <sam@rfc1149.net> (see http://www.jabber.org/)
X-OpenPGP-Fingerprint: 79C0 AE3C CEA8 F17B 0EF1  45A5 F133 2241 1B80 ADE6 (see http://www.gnupg.org/)
Message-Id: <2007-10-29-09-59-49+trackit+sam@rfc1149.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "marco" == marco gaddoni <marco.gaddoni@gmail.com> writes:

marco> i got this oops on my server.  the kernel is a
marco> 2.6.21-2-686 from the debian.

marco> this is an ext3 filesystem on a raid0 array of 2 ide disks.
marco> got the oops while doing a big rm.

marco> any idea on the possible cause?

Marco,

I also had one of these with 2.6.21 or around. Unfortunately, I did a
fsck (which solved it) before I could pinpoint the problem. It was on
a raid1 array with 2 sata disks and an ext3 filesystem so it may be
related either to the md driver, to the ext3 filesystem or something
else.

You can probably make the problem go away with a simple fsck, but if
you want to help find the cause of the problem, you can do one of the
following instead:

  - do a full copy (using dd) of your filesystem; however, if you're
    using a raid0 array, it may be because the filesystem is very
    large;

  - compile and boot a 2.6.24-rc1 kernel and see if the "rm" still
    generates a oops and help debug the problem.

 Sam
-- 
Samuel Tardieu -- sam@rfc1149.net -- http://www.rfc1149.net/

