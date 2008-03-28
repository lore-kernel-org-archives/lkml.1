Return-Path: <linux-kernel-owner+w=401wt.eu-S1753746AbYC1ItQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbYC1ItQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 04:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbYC1Is6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 04:48:58 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59872 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbYC1Is5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 04:48:57 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080327223624.GZ10722@ZenIV.linux.org.uk> (message from Al Viro
	on Thu, 27 Mar 2008 22:36:24 +0000)
Subject: Re: [patch 6/7] vfs: mountinfo: add /proc/<pid>/mountinfo
References: <20080327120619.031944658@szeredi.hu> <20080327122359.210920974@szeredi.hu> <20080327223624.GZ10722@ZenIV.linux.org.uk>
Message-Id: <E1JfAFw-0000dr-NB@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 28 Mar 2008 09:48:12 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static void show_type(struct seq_file *m, struct super_block *sb)
> > +{
> > +	mangle(m, sb->s_type->name);
> 
> BTW, do we really want to bother with quoting?  Anyway, that can live
> for now...

Right, type name shouldn't need quoting.  We might want to check at fs
registration, that name is alphanumeric+underscore only, so that
somebody doesn't get the idea to put spaces into filesystem names.

> 
> > +static int show_mountinfo(struct seq_file *m, void *v)
> > +{
> > +	struct proc_mounts *p = m->private;
> > +	size_t count_save = m->count;
> 
> > +		/*
> > +		 * Mountpoint is outside root, rewind seq_file. Ugly,
> > +		 * but necessary for race-free detection of unreachable
> > +		 * mountpoints.
> > +		 */
> > +		m->count = count_save;
> > +		return 0;
> > +	}
> 
> You know, _if_ we want to go that way, let's do it right; all callers
> of ->show() are in seq_file.c and all of them know the previous value
> of m->count.  So let's define SEQ_SKIP as 1 and teach these 3 callers
> to handle it.  And make this sucker (and anything else that might want
> the same kind of things) return SEQ_SKIP instead of playing with m->count
> directly.

Sounds good.

> Again, will do on merge...

Thanks,
Miklos
