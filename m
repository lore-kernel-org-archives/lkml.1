Return-Path: <linux-kernel-owner+w=401wt.eu-S1753204AbXFKOaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbXFKOaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 10:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbXFKOa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 10:30:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38648 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbXFKOa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 10:30:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: fix oops on cat /dev/snapshot
Date: Mon, 11 Jun 2007 16:36:42 +0200
User-Agent: KMail/1.9.5
Cc: B.Steinbrink@gmx.de, Andrew Morton <akpm@osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>
References: <20070611121716.GA1904@elf.ucw.cz>
In-Reply-To: <20070611121716.GA1904@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706111636.42555.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 11 June 2007 14:17, Pavel Machek wrote:
> What /dev/snapshot is simply cat-ed -- without ioctls used in normal
> operation -- it oopses. This one should fix it.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> --- clean-mm/kernel/power/user.c	2007-06-09 16:18:12.000000000 +0200
> +++ linux-mm/kernel/power/user.c	2007-06-11 14:06:19.000000000 +0200
> @@ -99,6 +99,8 @@
>  	ssize_t res;
>  
>  	data = filp->private_data;
> +	if (!data->ready)
> +		return -EINVAL;

I'd like to use -ENODATA here.

>  	res = snapshot_read_next(&data->handle, count);
>  	if (res > 0) {
>  		if (copy_to_user(buf, data_of(data->handle), res))
> 

I have a patch for that and I'm going to post it in a while if you don't
mind.

I've already posted it once, here: http://lkml.org/lkml/2007/6/10/146

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
