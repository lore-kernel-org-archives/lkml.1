Return-Path: <linux-kernel-owner+w=401wt.eu-S1752406AbZIYLhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbZIYLhu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 07:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbZIYLhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 07:37:48 -0400
Received: from mx.treblig.org ([80.68.94.177]:37406 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbZIYLhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 07:37:47 -0400
Date: Fri, 25 Sep 2009 13:37:47 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andreas Gruenbacher <agruen@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: new O_NODE open flag
Message-ID: <20090925123747.GA31228@gallifrey>
References: <E1Mqpfq-0003uZ-Pw@pomaz-ex.szeredi.hu> <200909250223.58664.agruen@suse.de> <E1Mr3jF-0005G4-Sf@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Mr3jF-0005G4-Sf@pomaz-ex.szeredi.hu>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.29.2-bytemark-kvm-tickless-2009-05-05 (i686)
X-Uptime: 13:35:56 up 122 days,  5:57,  1 user,  load average: 0.00, 0.00, 0.00
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Miklos Szeredi (miklos@szeredi.hu) wrote:
> On Fri, 25 Sep 2009, Andreas Gruenbacher wrote:
> > On Thursday, 24 September 2009 16:51:58 Miklos Szeredi wrote:
> > > This patch adds a new open flag, O_NODE.  This flag means: open just
> > > the filesystem node instead of the object referenced by the node.
> > 
> > What is the intended use for O_NODE?
> 
> It lets userspace file descriptors reference a inode without actually
> "dereferencing" it to get the underlying object.  This allows for a
> couple of new things:
> 
>  - opening a special file (device/socket/fifo) without side effects
> 
>  - opening a symlink
> 
>  - opening any type of file without any permission is also possible
>    (of course the resuling file descriptor may not be read or written)
> 
> The above allows fstat(), fchmod(), ioctl(), etc to be used for files
> previously not possible.

Given an fd opened in this way is it possible to reopen it normally and
be guarenteed to get the same object?

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
