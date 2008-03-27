Return-Path: <linux-kernel-owner+w=401wt.eu-S1752518AbYC0WnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbYC0WnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 18:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbYC0WnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 18:43:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33107 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbYC0WnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 18:43:01 -0400
Date: Thu, 27 Mar 2008 22:42:31 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 7/7] vfs: mountinfo: show dominating group id
Message-ID: <20080327224231.GA10722@ZenIV.linux.org.uk>
References: <20080327120619.031944658@szeredi.hu> <20080327122400.595798095@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080327122400.595798095@szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 01:06:26PM +0100, Miklos Szeredi wrote:
> +propagate_from:X  mount is slave and receives propagation from peer group X (*)
>  unbindable  mount is unbindable
>  
> +(*) X is the closest dominant peer group under the process's root.  If
> +X is the immediate master of the mount, or if there's no dominant peer
> +group under the same root, then only the "master:X" field is present
> +and not the "propagate_from:X" field.

Humm...  How does one distinguish between these variants?  Searching
in mountinfo for vfsmount with group ID of reported master?  We can
live with that, but it looks like a subtlety that will be cheerfully
forgotten by userland code.

Will do for now, but I think that we'll need that piece of documentation
more noticable and not so easy to overlook.
