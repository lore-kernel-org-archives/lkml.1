Return-Path: <linux-kernel-owner+w=401wt.eu-S966606AbYCTAY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966606AbYCTAY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938526AbYCSXfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:35:55 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50604 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758429AbYCSXfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:35:36 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080319111608.GI10722@ZenIV.linux.org.uk> (message from Al Viro
	on Wed, 19 Mar 2008 11:16:08 +0000)
Subject: Re: [patch 2/6] vfs: pnode cleanup
References: <20080313212641.989467982@szeredi.hu> <20080313212733.921047238@szeredi.hu> <20080319111608.GI10722@ZenIV.linux.org.uk>
Message-Id: <E1Jbwmm-00022R-O8@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 19 Mar 2008 12:48:48 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Mar 13, 2008 at 10:26:43PM +0100, Miklos Szeredi wrote:
> > Move set_mnt_shared from pnode.h to pnode.c.  Change
> > CLEAR_MNT_SHARED() to clear_mnt_shared() function, and move to
> > pnode.c.
> 
> I don't see why these two are a cleanup, actually.

People don't like my cleanups :( sniff...

> > @@ -89,20 +100,18 @@ static int do_make_slave(struct vfsmount
> >  		list_for_each_entry(slave_mnt, &mnt->mnt_slave_list, mnt_slave)
> >  			slave_mnt->mnt_master = master;
> >  		list_move(&mnt->mnt_slave, &master->mnt_slave_list);
> > -		list_splice(&mnt->mnt_slave_list, master->mnt_slave_list.prev);
> > -		INIT_LIST_HEAD(&mnt->mnt_slave_list);
> > +		list_splice_init(&mnt->mnt_slave_list,
> > +				 master->mnt_slave_list.prev);
> 
> Umm...  OK.

Yeah, not much of an improvement.

> >  	} else {
> > -		struct list_head *p = &mnt->mnt_slave_list;
> > -		while (!list_empty(p)) {
> > -                        slave_mnt = list_first_entry(p,
> > +		while (!list_empty(&mnt->mnt_slave_list)) {
> > +			slave_mnt = list_first_entry(&mnt->mnt_slave_list,
> 
> How is that better?

I find it easier to read.  Renaming "p" to "slaves" would also have
been better.  Single letter variables are reserved for iterators in my
mind...

Miklos
