Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097AbXISWYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbXISWYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 18:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbXISWY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 18:24:28 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:34032 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbXISWY2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 18:24:28 -0400
Message-ID: <46F1A196.8060108@davidnewall.com>
Date: Thu, 20 Sep 2007 07:54:22 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Bill Davidsen <davidsen@tmr.com>, majkls <majkls@prepere.com>,
       bunk@fs.tum.de, linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
References: <46F0CD96.9030807@prepere.com>	<20070919104018.3a6bcfb1@the-village.bc.nu>	<46F16A0A.3070402@tmr.com> <20070919194559.36015307@the-village.bc.nu>
In-Reply-To: <20070919194559.36015307@the-village.bc.nu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Normal users cannot use chroot() themselves so they can't use chroot to
> get back out

I think Bill is right, that this is to fix a method that non-root 
processes can use to escape their chroot. The exploit, which is 
documented in chroot(2)*, is to chdir("..") your way out. Who'd have 
thought it? Only root can do that, but even that seems wrong. Chroot 
should be chroot and that should be the end of it.

It looks to me like Miloslav has found a bug, although I suspect there's 
a simpler solution because non-root is already prevented from escaping 
this way.

David

* In particular, the superuser can escape from a ‘chroot jail’ by doing 
‘mkdir foo; chroot foo; cd ..’.

