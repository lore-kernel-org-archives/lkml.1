Return-Path: <linux-kernel-owner+w=401wt.eu-S1757984AbYDTRxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbYDTRxl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 13:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754976AbYDTRxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 13:53:31 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:58320 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbYDTRxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 13:53:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=sgD9CSA4GlRlH9+NyxcCNdwOaNHy0sPe1Yq5pxIM0X/c5e4RgVGF1vcuQStVOPuOBP+mkFLppJEh5sKtSPCBh06a9LjP8yiJLq+Hp+6cJxHHANfSCdayTeuro7mqZoaQNIQJ07WrfFV1n70dBrPKnOtp/QNkfvFl427PTywOUl4=
Date: Sun, 20 Apr 2008 22:48:48 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Denis V. Lunev" <den@openvz.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       bfields@fieldses.org, ebiederm@xmission.com, neilb@suse.de
Subject: Re: + nfsd-use-proc_create-to-setup-de-proc_fops.patch added to
	-mm tree
Message-ID: <20080420184848.GA31337@martell.zuzino.mipt.ru>
References: <200804152355.m3FNtv3O022485@imap1.linux-foundation.org> <20080420143759.GB32520@martell.zuzino.mipt.ru> <1208708509.14894.3.camel@iris.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208708509.14894.3.camel@iris.sw.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 08:21:49PM +0400, Denis V. Lunev wrote:
> 
> On Sun, 2008-04-20 at 18:37 +0400, Alexey Dobriyan wrote:
> > On Tue, Apr 15, 2008 at 04:55:57PM -0700, akpm@linux-foundation.org wrote:
> > > --- a/fs/nfsd/nfsctl.c~nfsd-use-proc_create-to-setup-de-proc_fops
> > > +++ a/fs/nfsd/nfsctl.c
> > 
> > > @@ -736,10 +737,9 @@ static int create_proc_exports_entry(voi
> > >  	entry = proc_mkdir("fs/nfs", NULL);
> > >  	if (!entry)
> > >  		return -ENOMEM;
> > > -	entry = create_proc_entry("fs/nfs/exports", 0, NULL);
> > > +	entry = proc_create("exports", 0, entry, &exports_operations);
> > 			    ^^^^^^^^^
>                                            ^^^^^^^
> > >  	if (!entry)
> > >  		return -ENOMEM;
> > > -	entry->proc_fops =  &exports_operations;
> > 
> > "fs/nfs/exports" is used in full in this file. And line will fit into
> > 80 columns.
> > 
> This is a pde for fs/nfs.

Yes, why change it?

> So, this will be slightly less operations in my case.

It's done once per module loading, so nobody cares.

