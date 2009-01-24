Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbZAXH1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbZAXH1T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 02:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbZAXH1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 02:27:07 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:59092 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbZAXH1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 02:27:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JpBdpdgXtkDtqIWSb+xWIOHlP+iCBQioeOFDwiU0a6TKAEqK1dAULawy49HDSO47aM
         E7IFPGViAk3S+SmGwBRgZqJY4uS7vTl1uN6SEai64AFmVfAubaoz+E3Eqdx6ulMkZ03u
         WNn8EY/qDGJMXqdKv4yDt3+npUDERJ9QHkcms=
Date: Sat, 24 Jan 2009 10:32:36 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: reiserfs-devel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: usr/include/linux/reiserfs_fs.h is having lot of KERNEL data
Message-ID: <20090124073236.GA6166@x200.localdomain>
References: <1232465242.3088.25.camel@localhost.localdomain> <1232778934.10414.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232778934.10414.4.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 24, 2009 at 12:05:34PM +0530, Jaswinder Singh Rajput wrote:
> On Tue, 2009-01-20 at 20:57 +0530, Jaswinder Singh Rajput wrote:
> > usr/include/linux/reiserfs_fs.h is giving 21 'make headers_clean' warnings:
> >  usr/include/linux/reiserfs_fs.h:64: leaks CONFIG_REISERFS to userspace where it is not valid
> >  usr/include/linux/reiserfs_fs.h:81: leaks CONFIG_REISERFS to userspace where it is not valid
> >  usr/include/linux/reiserfs_fs.h:687: extern's make no sense in userspace
> >  usr/include/linux/reiserfs_fs.h:995: extern's make no sense in userspace
> >  usr/include/linux/reiserfs_fs.h:997: extern's make no sense in userspace
> >  usr/include/linux/reiserfs_fs.h:1467: extern's make no sense in userspace
> >  usr/include/linux/reiserfs_fs.h:1587: leaks CONFIG_QUOTA to userspace where it is not valid
> >  usr/include/linux/reiserfs_fs.h:1760: extern's make no sense in userspace
> >  usr/include/linux/reiserfs_fs.h:1764: extern's make no sense in userspace 
> >  usr/include/linux/reiserfs_fs.h:1766: extern's make no sense in userspace
> >  usr/include/linux/reiserfs_fs.h:1769: extern's make no sense in userspace
> >  usr/include/linux/reiserfs_fs.h:1771: extern's make no sense in userspace
> >  usr/include/linux/reiserfs_fs.h:1805: extern's make no sense in userspace
> >  usr/include/linux/reiserfs_fs.h:1908: leaks CONFIG_PROC to userspace where it is not valid
> >  usr/include/linux/reiserfs_fs.h:1948: extern's make no sense in userspace
> >  usr/include/linux/reiserfs_fs.h:1949: extern's make no sense in userspace
> >  usr/include/linux/reiserfs_fs.h:1950: extern's make no sense in userspace
> >  usr/include/linux/reiserfs_fs.h:1951: extern's make no sense in userspace
> >  usr/include/linux/reiserfs_fs.h:1962: extern's make no sense in userspace
> >  usr/include/linux/reiserfs_fs.h:1963: extern's make no sense in userspace
> >  usr/include/linux/reiserfs_fs.h:1964: extern's make no sense in userspace
> > 
> > This file is huge and need lot of cleanup.
> > 
> 
> 
> If no one have any objections can I forward this patch to fix above
> warnings:

This file need more throrough cleanup than some tool thinks it needs to be:

> --- a/include/linux/reiserfs_fs.h
> +++ b/include/linux/reiserfs_fs.h
> @@ -74,9 +74,7 @@ struct fid;
>  // FIXME: do not change 4 by anything else: there is code which relies on that
>  #define ROUND_UP(x) _ROUND_UP(x,8LL)
>  
> -/* debug levels.  Right now, CONFIG_REISERFS_CHECK means print all debug
> -** messages.
> -*/
> +/* debug levels.  Right now, REISERFS_CHECK means print all debug messages */

Whoa, fix the tool!

> @@ -91,11 +89,13 @@ if( !( cond ) ) 								\
>  
>  #define RASSERT(cond, format, args...) __RASSERT(cond, #cond, format, ##args)
>  
> +#ifdef __KERNEL__

What about RASSERT?

>  #if defined( CONFIG_REISERFS_CHECK )
>  #define RFALSE(cond, format, args...) __RASSERT(!(cond), "!(" #cond ")", format, ##args)
>  #else
>  #define RFALSE( cond, format, args... ) do {;} while( 0 )
>  #endif
> +#endif
>  
>  #define CONSTF __attribute_const__
>  /*
> @@ -698,7 +698,9 @@ static inline void cpu_key_k_offset_dec(struct cpu_key *key)
>  /* object identifier for root dir */
>  #define REISERFS_ROOT_OBJECTID 2
>  #define REISERFS_ROOT_PARENT_OBJECTID 1
> +#ifdef __KERNEL__
>  extern struct reiserfs_key root_key;
> +#endif /* __KERNEL__ */
>  
>  /* 
>   * Picture represents a leaf of the S+tree
> @@ -1006,10 +1008,12 @@ struct reiserfs_de_head {
>  #define de_visible(deh)	    	    test_bit_unaligned (DEH_Visible, &((deh)->deh_state))
>  #define de_hidden(deh)	    	    !test_bit_unaligned (DEH_Visible, &((deh)->deh_state))
>  
> +#ifdef __KERNEL__
>  extern void make_empty_dir_item_v1(char *body, __le32 dirid, __le32 objid,
>  				   __le32 par_dirid, __le32 par_objid);
>  extern void make_empty_dir_item(char *body, __le32 dirid, __le32 objid,
>  				__le32 par_dirid, __le32 par_objid);
> +#endif /* __KERNEL__ */
>  
>  /* array of the entry headers */
>   /* get item body */
> @@ -1478,7 +1482,9 @@ struct item_operations {
>  	void (*print_vi) (struct virtual_item * vi);
>  };
>  
> +#ifdef __KERNEL__
>  extern struct item_operations *item_ops[TYPE_ANY + 1];
> +#endif /* __KERNEL__ */

item_ops are unused, AFAICS.

> @@ -1688,6 +1696,7 @@ struct reiserfs_jh {

struct reiserfs_jh is kernel-internal as well.
