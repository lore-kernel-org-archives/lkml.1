Return-Path: <linux-kernel-owner+w=401wt.eu-S1759626AbXIXVch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626AbXIXVch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 17:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759118AbXIXVcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 17:32:21 -0400
Received: from smtp108.sbc.mail.mud.yahoo.com ([68.142.198.207]:23007 "HELO
	smtp108.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759048AbXIXVcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 17:32:20 -0400
X-YMail-OSG: mH8rNmAVM1nJY2n8vG5RwmgUviBRGtp8iGSiNK11R.7evIEUFJOtjf3zAZWhJFpQDg1uAoGn8w--
Date: Mon, 24 Sep 2007 16:32:15 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: David Newall <david@davidnewall.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Philipp Marek <philipp@marek.priv.at>,
       7eggert@gmx.de, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       majkls <majkls@prepere.com>, bunk@fs.tum.de,
       linux-kernel@vger.kernel.org
Subject: Re: sys_chroot+sys_fchdir Fix
Message-ID: <20070924213215.GA32716@vino.hallyn.com>
References: <952DN-83o-31@gated-at.bofh.it> <56705.193.171.152.61.1190289559.squirrel@webmail.marek.priv.at> <46F29A9A.4070806@davidnewall.com> <200709201817.17282@x5> <46F2B59F.8090709@davidnewall.com> <46F2DDD0.3030500@tmr.com> <46F380E4.4040606@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F380E4.4040606@davidnewall.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Newall (david@davidnewall.com):
> Bill Davidsen wrote:
>> there is no question that pivot_root is intended to have breadth for more 
>> than one process. 
>
> I think it's clear from the man page that the original idea was to be able 
> to pivot_root for individual processes.  The reason it doesn't do that, the 
> reason it affects all processes, is to work around the bootstrap problem, 
> where processes that don't care what their root (or current) directory is 
> are still using the original root.
>
> An extra parameter could be added to specify which behavior is desired, 
> probably defaulting to the current behavior. That would remove the need to 
> use a chroot bug.

No reason for any new parameters to pivot_root.  Just clone your mounts
namespace first.

	unshare(CLONE_NEWNS);
	chdir(new_dir);
	pivot_root(new_dir, oldroot);

Since pivot_root actually fiddles with the vfsmnts, this is really the
only way to go about having it "work with just one process".

-serge

