Return-Path: <linux-kernel-owner+w=401wt.eu-S1756238AbYFBQ4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbYFBQ4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 12:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbYFBQ4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 12:56:14 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:48684 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbYFBQ4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 12:56:12 -0400
Date: Mon, 2 Jun 2008 20:52:23 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Toshiharu Harada <haradats@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       jmorris@namei.org, sds@tycho.nsa.gov, eparis@redhat.com,
       casey@schaufler-ca.com, agruen@suse.de, jjohansen@suse.de,
       penguin-kernel@i-love.sakura.ne.jp, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 01/15] security: pass path to inode_create
Message-ID: <20080602165223.GA9121@2ka.mipt.ru>
References: <20080602091341.GA8011@infradead.org> <E1K36PE-0002wZ-0M@pomaz-ex.szeredi.hu> <20080602093630.GA25254@infradead.org> <E1K36ii-0002zj-Gn@pomaz-ex.szeredi.hu> <20080602104203.GA21898@infradead.org> <E1K37hN-00039y-5o@pomaz-ex.szeredi.hu> <20080602150517.GB22400@2ka.mipt.ru> <9d732d950806020831h1b8aeabag9cb6db8e16bac971@mail.gmail.com> <20080602155152.GA18257@2ka.mipt.ru> <9d732d950806020929v1ece55ecobabc418425c1e044@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d732d950806020929v1ece55ecobabc418425c1e044@mail.gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 01:29:33AM +0900, Toshiharu Harada (haradats@gmail.com) wrote:
> > For those who care exactly about path, they do not want to have security
> > checks for object, which was there. As addition, selinux
> > maintainer/architector opinion is a bit biassed :)
> 
> This is a very important point.
> 
> The world of Linux consists of the two pieces, userland and kernel.
> Objects have names and inodes. Information flow control need to be
> handled using inodes (labels), but pathnames need to be
> controlled because objects are represented by names in userland.
> Both pieces work together. Vfsmount is a missing piece.
> 
> AppArmor and TOMOYO Linux are not claiming they are better MAC for Linux.
> (that's how I understood Stephen's words. I am agreed)
> So people don't have to eliminate pathname-based MACs.

They can, if really want, to get vfsmount.

A hint: there is security_sb_check_sb() and security_sb_post_addmount().
Store that vsmount in private cache, search the very root dentry for any inode
inside that cache of vfsmounts and get a pointer. Looks a bit ugly
though, and slower (really a bit), but it can solve a problem.
It is also possible to implement own path cache isntead of using dentry
cache, since apparently dentry is not needed neither to apparmor nor to
tomoyo, but path info (in own format). And that will be even better
solution, since it will be exactly what selinux does with its data. 
Only to different objects. This will complicate move/rename and other
pathname manipulation. There are of course underwater rocks, but they
can be worked out with existing inode-biased approach.

-- 
	Evgeniy Polyakov
