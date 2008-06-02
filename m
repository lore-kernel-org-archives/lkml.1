Return-Path: <linux-kernel-owner+w=401wt.eu-S1757977AbYFBHSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977AbYFBHSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 03:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbYFBHSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 03:18:01 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:56286 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbYFBHSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 03:18:01 -0400
Date: Mon, 2 Jun 2008 09:17:59 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: Arnd Bergmann <arnd@arndb.de>, Jamie Lokier <jamie@shareable.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       David Newall <davidn@davidnewall.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [RFC 0/7] [RFC] cramfs: fake write support 
In-Reply-To: <200806020437.m524bWiW027508@agora.fsl.cs.sunysb.edu>
Message-ID: <alpine.LNX.1.10.0806020857580.4055@fbirervta.pbzchgretzou.qr>
References: <200806020437.m524bWiW027508@agora.fsl.cs.sunysb.edu>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2008-06-02 06:37, Erez Zadok wrote:
>> Jan Engelhardt wrote:
>> > On Sunday 2008-06-01 08:02, David Newall wrote:
>> >>   
>> >>> I prefer the technique of union of a tmpfs over some other fs
>> >>
>> >> You're right in principle, but unfortunately there is to date no working
>> >> implementation of union mounts. Giving users the option of using an
>> >> existing file system with a few tweaks can only be better than than
>> >> forcing them to use hacks like unionfs.

>Folks, I've said it before: unioning is a deceptively simple idea in
>principle, and &^@%*$&^@ hard in practice.  And anyone who thinks otherwise
>is welcome to write a *versatile* unioning implementation on their own. Once
>you get through all corner cases and satisfy all the features which users
>want, you have a complex large file system.
>[...]

To the original posters:

I urge those who do believe {au,union}fs is too fat to go and build
their unioning into their on-disk filesystems, then let users run it
(remark: iff you can convince (or force) them why they should not be
using existing fs), let users report issues and iron it out for
perhaps 2-3 years, and then see how much your implementation has
grown. That is, if you actually added code (see remark 1).

About last year (June 2007), SLAX sought a solution that enhances
VFAT with UNIX permissions -- much like the old umsdosfs. A kernel
solution was initially preferred by Tomas (SLAX developer), yet I
(who got to write posixovl then) went for FUSE. It was about 20 KB
when it was moderately usable. The end result? Posixovl is a 46 KB C
file today. For userspace code. I bet it would be much more if it was
in-kernel.

Take that as a hint when developing your fs-specific unioning.
