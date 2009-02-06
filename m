Return-Path: <linux-kernel-owner+w=401wt.eu-S1758746AbZBFSwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746AbZBFSwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 13:52:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbZBFSvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 13:51:52 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:46196 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbZBFSvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 13:51:51 -0500
Date: Fri, 6 Feb 2009 12:51:42 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, hpa@zytor.com, hch@lst.de,
       sukadev@us.ibm.com, Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [v2][PATCH 5/5] Merge code for single and multiple-instance
	mounts
Message-ID: <20090206185142.GA29582@us.ibm.com>
References: <20090204043516.GB25963@us.ibm.com> <20090204043813.GE26202@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204043813.GE26202@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sukadev Bhattiprolu (sukadev@linux.vnet.ibm.com):
> 
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Date: Wed, 28 Jan 2009 19:11:15 -0800
> Subject: [v2][PATCH 5/5] Merge code for single and multiple-instance mounts
> 
> new_pts_mount() (including the get_sb_nodev()), shares a lot of code
> with init_pts_mount(). The only difference between them is the 'test-super'
> function passed into sget().
> 
> Move all common code into devpts_get_sb() and remove the new_pts_mount() and
> init_pts_mount() functions,
> 
> Changelog[v2]:
> 	(Christoph Hellwig): Merge code in 'do_pts_mount()' into devpts_get_sb()
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>
Tested-by: Serge Hallyn <serue@us.ibm.com>

except that:

> @@ -414,24 +365,41 @@ static int devpts_get_sb(struct file_system_type *fs_type,
>  			return error;
>  	}
> 
> -	if (opts.newinstance)
> -		error = new_pts_mount(fs_type, flags, data, &opts, mnt);
> -	else
> -		error = init_pts_mount(fs_type, flags, data, &opts, mnt);
> +	if (opts.newinstance) {
> +		printk(KERN_NOTICE "devpts: newinstance mount\n");
> +		s = sget(fs_type, NULL, set_anon_super, NULL);
> +	} else {
> +		printk(KERN_NOTICE "devpts: single-instance mount\n");

These printks probably shouldn't stay in...

> +		s = sget(fs_type, compare_init_pts_sb, set_anon_super, NULL);
> +	}

thanks,
-serge
