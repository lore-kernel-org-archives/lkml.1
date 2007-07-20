Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbXGTEwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbXGTEwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 00:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbXGTEwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 00:52:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:3605 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbXGTEwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 00:52:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=tAWBtWyaop7ashbEeOw2zGgq/Evof1rMMt3AgiYkRdPiwEY9EQ7doO39Jlv//BC7MPVTCnLT7Q8G77F9udMKwbsAs38upyrqDqpzhhYXc8ioUbc7WeYp9648S/n8icFsme9See3L4Sc0UnSfuS23eAk0zDxakwMXARKW+3m8NhM=
Date: Fri, 20 Jul 2007 08:52:16 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Ogrisegg <tom-lkml@lkml.fnord.at>, linux-kernel@vger.kernel.org,
       rml@novell.com, John McCutchan <ttb@tentacle.dhs.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, robin.ksj@gmail.com
Subject: Re: [PATCH] procfs fixes for inotify/dnotify
Message-ID: <20070720045216.GA5831@martell.zuzino.mipt.ru>
References: <20060221211623.GA26413@rescue.iwoars.net> <20070719150355.2971e8e4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719150355.2971e8e4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 03:03:55PM -0700, Andrew Morton wrote:
> 	http://bugzilla.kernel.org/show_bug.cgi?id=8782

[fsnotify and /proc]

> > --- linux-2.6.15/fs/proc/base.c
> > +++ linux-2.6.15.4/fs/proc/base.c
> > @@ -1945,6 +1945,7 @@
> >  	if(proc_dentry != NULL) {
> >  		shrink_dcache_parent(proc_dentry);
> >  		dput(proc_dentry);
> > +		fsnotify_nameremove (proc_dentry, 1);
> >  	}
> 
> I wonder if this is racy - after the dput() we might no longer have a
> reference?

It is indeed racy. dput() => kill_it: => d_kill() => d_free() =>
__d_free() eventually. *boom*

