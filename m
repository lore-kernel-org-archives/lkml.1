Return-Path: <linux-kernel-owner+w=401wt.eu-S932242AbXE1UjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242AbXE1UjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 16:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbXE1UjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 16:39:13 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2068 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751490AbXE1UjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 16:39:11 -0400
Date: Mon, 28 May 2007 20:38:38 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Valdis.Kletnieks@vt.edu, Toshiharu Harada <haradats@gmail.com>,
       James Morris <jmorris@namei.org>, casey@schaufler-ca.com,
       Andreas Gruenbacher <agruen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Message-ID: <20070528203838.GB5840@ucw.cz>
References: <309300.41401.qm@web36615.mail.mud.yahoo.com> <B4A3C582-68F9-4077-B058-03B79A5577EB@mac.com> <Line.LNX.4.64.0705261442000.23020@d.namei> <9d732d950705261608j4bc72cd4s4378df9848101c84@mail.gmail.com> <EC769668-ED57-4D6D-80B2-1BFD039E113C@mac.com> <12000.1180233422@turing-police.cc.vt.edu> <D9C70A8C-2307-4E5F-AE5F-2A347284B879@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D9C70A8C-2307-4E5F-AE5F-2A347284B879@mac.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>That's a circular argument, and a fairly trivial one 
> >>at that.  If you
> >>can't properly manage your labels, then how do you 
> >>expect any
> >>security at all?
> >
> >Unfortunately, it's not at all as simple as all that. 
> >Toshiharu is  quite correct that it isn't always easy 
> >to actually implement.   Consider how many ad-croc 
> >usages of 'restorecon' are needed to get  a Fedora 
> >SELinux box through rc.sysinit:
> 
> While I don't think restorecon is really necessary to 
> properly boot  SELinux-enabled (I've got a Debian box 
> with some heavily customized  policy which does so just 
> fine), I am of the opinion that adding a  "name" 
> parameter to the file/directory create actions would be  
> useful.  For example, with such support you could 
> actually specify a  type-transition rule conditional on 
> a specific name or substring:
> 
> named_type_transition sshd_t tmp_t:sock_file prefix 
> "ssh-" ssh_sock_t;
> 
> Useful options for matching would be "prefix", "suffix", 
> "substr (start,len)".  "regex" would be nice but is 
> sorta computationally  intensive and would be likely to 
> cause more problems than it solves.

Could someone implement this? AFAICT that prevents SELinux from being
superset of AppArmor... Doing this should be significantly simpler
than whole AA, and hopefully it will end up less ugly, too.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
