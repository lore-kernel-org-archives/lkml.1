Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbYDTN5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbYDTN5v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 09:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752063AbYDTN5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 09:57:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:54858 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbYDTN5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 09:57:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=WvXkvYmEV4njZVhOzh8Qh56ulnmlR/skFEhKG9H52BG7D9xKXTd3ut2hmF3YGyH5gcga/CVQxJ8BL06sS7fUHnkTcVThm8dBZXw2rLCDEw2tStu3NJQNFmEHwccjHO4e8Q3O9nrpd/fETUWM6LA1J2LBHDKO4wR5070ugleuOhk=
Date: Sun, 20 Apr 2008 18:53:00 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, den@openvz.org, dhowells@redhat.com,
       ebiederm@xmission.com
Subject: Re: + afs-use-non-racy-method-for-proc-entries-creation.patch
	added to -mm tree
Message-ID: <20080420145300.GC32520@martell.zuzino.mipt.ru>
References: <200804152356.m3FNu2aB022497@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804152356.m3FNu2aB022497@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 04:56:01PM -0700, akpm@linux-foundation.org wrote:
> --- a/fs/afs/proc.c~afs-use-non-racy-method-for-proc-entries-creation
> +++ a/fs/afs/proc.c
> @@ -395,26 +396,20 @@ int afs_proc_cell_setup(struct afs_cell 
>  	if (!cell->proc_dir)
>  		goto error_dir;
>  
> -	p = create_proc_entry("servers", 0, cell->proc_dir);
> +	p = proc_create_data("servers", 0, cell->proc_dir,
> +			     &afs_proc_cell_servers_fops, cell);
>  	if (!p)
>  		goto error_servers;
> -	p->proc_fops = &afs_proc_cell_servers_fops;
> -	p->owner = THIS_MODULE;
> -	p->data = cell;
>  
> -	p = create_proc_entry("vlservers", 0, cell->proc_dir);
> +	p = proc_create_data("vlservers", 0, cell->proc_dir,
> +			     &afs_proc_cell_vlservers_fops, cell);
>  	if (!p)
>  		goto error_vlservers;
> -	p->proc_fops = &afs_proc_cell_vlservers_fops;
> -	p->owner = THIS_MODULE;
> -	p->data = cell;
>  
> -	p = create_proc_entry("volumes", 0, cell->proc_dir);
> +	p = proc_create_data("volumes", 0, cell->proc_dir,
> +			     &afs_proc_cell_volumes_fops, cell);
>  	if (!p)
>  		goto error_volumes;
> -	p->proc_fops = &afs_proc_cell_volumes_fops;
> -	p->owner = THIS_MODULE;
> -	p->data = cell;

Checks for NULL "cell" are still in place, however.
In afs_proc_cell_servers_open(), afs_proc_cell_vlservers_open(), and
afs_proc_cell_volumes_fops().

