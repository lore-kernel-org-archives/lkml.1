Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbYDTNmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbYDTNmr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 09:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbYDTNmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 09:42:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:36385 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbYDTNmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 09:42:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=AEiyX1Ct8JOxweLnBUNUShgBT6amNxd+ZHHL9EBnZo3WRWQPYOKgSbc+mnjFNwnn2H9no8gt0U0DBhHVpzf9rcfQEbyNJcDo0jvXWLU8ydIJ0ZW15ofcMZL9SDkAUl6ghMsBCGj/TgGLKUfNWi+xy5JlHZGJAL+UGJ+kxeBmwdM=
Date: Sun, 20 Apr 2008 18:37:59 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, den@openvz.org, bfields@fieldses.org,
       ebiederm@xmission.com, neilb@suse.de
Subject: Re: + nfsd-use-proc_create-to-setup-de-proc_fops.patch added to
	-mm tree
Message-ID: <20080420143759.GB32520@martell.zuzino.mipt.ru>
References: <200804152355.m3FNtv3O022485@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804152355.m3FNtv3O022485@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 04:55:57PM -0700, akpm@linux-foundation.org wrote:
> --- a/fs/nfsd/nfsctl.c~nfsd-use-proc_create-to-setup-de-proc_fops
> +++ a/fs/nfsd/nfsctl.c

> @@ -736,10 +737,9 @@ static int create_proc_exports_entry(voi
>  	entry = proc_mkdir("fs/nfs", NULL);
>  	if (!entry)
>  		return -ENOMEM;
> -	entry = create_proc_entry("fs/nfs/exports", 0, NULL);
> +	entry = proc_create("exports", 0, entry, &exports_operations);
			    ^^^^^^^^^
>  	if (!entry)
>  		return -ENOMEM;
> -	entry->proc_fops =  &exports_operations;

"fs/nfs/exports" is used in full in this file. And line will fit into
80 columns.

