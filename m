Return-Path: <linux-kernel-owner+w=401wt.eu-S1751954AbZJTMJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbZJTMJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 08:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbZJTMJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 08:09:27 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:61812 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbZJTMJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 08:09:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LOc5Kc/HXjlhi3RcIxPJZm926ljNv/TcpqZBrst0YdP4AnIpewEIK3q2scuJMlZ75b
         7nv6Sb4FCX+LWUHshADVfwvuF7lU7aGFDszx+wwpzZovUGtWARp9m3Nhosw1XgdwUppf
         QLL11y65Hue+bBgxRcpkEFOjMTz0lsj2hAbwY=
Date: Tue, 20 Oct 2009 16:09:26 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, dlezcano@fr.ibm.com, ebiederm@xmission.com,
       jack@ucw.cz, andrea@cpushare.com, sukadev@us.ibm.com,
       Containers <containers@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       mingo@elte.hu
Subject: Re: [PATCH] pidns: Fix a leak in /proc inodes and dentries
Message-ID: <20091020120926.GA28909@x200>
References: <20091020041337.GA31623@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091020041337.GA31623@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 09:13:37PM -0700, Sukadev Bhattiprolu wrote:
> --- linux-2.6.orig/fs/proc/base.c
> +++ linux-2.6/fs/proc/base.c
> @@ -2580,8 +2580,7 @@ static void proc_flush_task_mnt(struct v
>  	name.len = snprintf(buf, sizeof(buf), "%d", pid);
>  	dentry = d_hash_and_lookup(mnt->mnt_root, &name);
>  	if (dentry) {
> -		if (!(current->flags & PF_EXITING))
> -			shrink_dcache_parent(dentry);
> +		shrink_dcache_parent(dentry);

What to do with original deadlock?
