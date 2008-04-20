Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbYDTQV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbYDTQV4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 12:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbYDTQVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 12:21:48 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:49083 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768AbYDTQVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 12:21:48 -0400
Subject: Re: + nfsd-use-proc_create-to-setup-de-proc_fops.patch added to
	-mm tree
From: "Denis V. Lunev" <den@openvz.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       bfields@fieldses.org, ebiederm@xmission.com, neilb@suse.de
In-Reply-To: <20080420143759.GB32520@martell.zuzino.mipt.ru>
References: <200804152355.m3FNtv3O022485@imap1.linux-foundation.org>
	 <20080420143759.GB32520@martell.zuzino.mipt.ru>
Content-Type: text/plain
Organization: OpenVz kernel team
Date: Sun, 20 Apr 2008 20:21:49 +0400
Message-Id: <1208708509.14894.3.camel@iris.sw.ru>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-04-20 at 18:37 +0400, Alexey Dobriyan wrote:
> On Tue, Apr 15, 2008 at 04:55:57PM -0700, akpm@linux-foundation.org wrote:
> > --- a/fs/nfsd/nfsctl.c~nfsd-use-proc_create-to-setup-de-proc_fops
> > +++ a/fs/nfsd/nfsctl.c
> 
> > @@ -736,10 +737,9 @@ static int create_proc_exports_entry(voi
> >  	entry = proc_mkdir("fs/nfs", NULL);
> >  	if (!entry)
> >  		return -ENOMEM;
> > -	entry = create_proc_entry("fs/nfs/exports", 0, NULL);
> > +	entry = proc_create("exports", 0, entry, &exports_operations);
> 			    ^^^^^^^^^
                                           ^^^^^^^
> >  	if (!entry)
> >  		return -ENOMEM;
> > -	entry->proc_fops =  &exports_operations;
> 
> "fs/nfs/exports" is used in full in this file. And line will fit into
> 80 columns.
> 
This is a pde for fs/nfs. So, this will be slightly less operations in
my case.

