Return-Path: <linux-kernel-owner+w=401wt.eu-S1760322AbXIXWEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760322AbXIXWEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 18:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756101AbXIXWEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 18:04:41 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:34186 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737AbXIXWEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 18:04:40 -0400
Message-ID: <46F83474.5040503@davidnewall.com>
Date: Tue, 25 Sep 2007 07:34:36 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: Bill Davidsen <davidsen@tmr.com>, Philipp Marek <philipp@marek.priv.at>,
       7eggert@gmx.de, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       majkls <majkls@prepere.com>, bunk@fs.tum.de,
       linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
References: <952DN-83o-31@gated-at.bofh.it> <56705.193.171.152.61.1190289559.squirrel@webmail.marek.priv.at> <46F29A9A.4070806@davidnewall.com> <200709201817.17282@x5> <46F2B59F.8090709@davidnewall.com> <46F2DDD0.3030500@tmr.com> <46F380E4.4040606@davidnewall.com> <20070924213215.GA32716@vino.hallyn.com>
In-Reply-To: <20070924213215.GA32716@vino.hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> No reason for any new parameters to pivot_root.  Just clone your mounts
> namespace first.
>
> 	unshare(CLONE_NEWNS);
> 	chdir(new_dir);
> 	pivot_root(new_dir, oldroot);
>
> Since pivot_root actually fiddles with the vfsmnts, this is really the
> only way to go about having it "work with just one process".

I think the point is that, whereas we'd like to be able to pivot the 
root for a single process, in practice this causes startup issues to 
which the easy solution is to pivot the whole system.  At least that's 
my reading of the man page.

It might be tidy if pivot_root could be used (instead of a hack based on 
a chroot bug), but it'd still be unportable.
