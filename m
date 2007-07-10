Return-Path: <linux-kernel-owner+w=401wt.eu-S1761560AbXGJXsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761560AbXGJXsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 19:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbXGJXsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 19:48:33 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39750 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbXGJXsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 19:48:32 -0400
Subject: Re: [EXT4 set 1][PATCH 1/2] Add noextents mount option
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
In-Reply-To: <20070710163012.6e0ded75.akpm@linux-foundation.org>
References: <1183275348.4010.118.camel@localhost.localdomain>
	 <20070710163012.6e0ded75.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Tue, 10 Jul 2007 16:48:33 -0400
Message-Id: <1184100513.3759.31.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-10 at 16:30 -0700, Andrew Morton wrote:
> On Sun, 01 Jul 2007 03:35:48 -0400
> Mingming Cao <cmm@us.ibm.com> wrote:
> 
> > Add a mount option to turn off extents.
> 
> Please update the changelog to describe the reason for making this change.
> 
> 

Sure, I will update the changelog, mainly this is for wide testing of
extents feature in ext4dev.

> > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> > ---
> > Index: linux-2.6.22-rc4/fs/ext4/super.c
> > ===================================================================
> > --- linux-2.6.22-rc4.orig/fs/ext4/super.c	2007-06-11 17:02:18.000000000 -0700
> > +++ linux-2.6.22-rc4/fs/ext4/super.c	2007-06-11 17:02:22.000000000 -0700
> > @@ -725,7 +725,7 @@
> >  	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
> >  	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
> >  	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
> > -	Opt_grpquota, Opt_extents,
> > +	Opt_grpquota, Opt_extents, Opt_noextents,
> >  };
> >  
> >  static match_table_t tokens = {
> > @@ -776,6 +776,7 @@
> >  	{Opt_usrquota, "usrquota"},
> >  	{Opt_barrier, "barrier=%u"},
> >  	{Opt_extents, "extents"},
> > +	{Opt_noextents, "noextents"},
> >  	{Opt_err, NULL},
> >  	{Opt_resize, "resize"},
> >  };
> > @@ -1111,6 +1112,9 @@
> >  		case Opt_extents:
> >  			set_opt (sbi->s_mount_opt, EXTENTS);
> >  			break;
> > +		case Opt_noextents:
> > +			clear_opt (sbi->s_mount_opt, EXTENTS);
> > +			break;
> >  		default:
> >  			printk (KERN_ERR
> >  				"EXT4-fs: Unrecognized mount option \"%s\" "
> > 
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/

