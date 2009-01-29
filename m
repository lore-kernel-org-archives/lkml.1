Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbZA2INU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbZA2INU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 03:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbZA2INL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 03:13:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752522AbZA2INK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 03:13:10 -0500
Date: Thu, 29 Jan 2009 00:12:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/2] epoll remove debugging code
Message-Id: <20090129001251.7a39d957.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0901271253010.20262@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0901271253010.20262@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009 12:54:58 -0800 (PST) Davide Libenzi <davidel@xmailserver.org> wrote:

> static int ep_eventpoll_release(struct inode *inode, struct file *file)
>  {
> -	struct eventpoll *ep = file->private_data;
> -
> -	if (ep)
> -		ep_free(ep);
> +	if (file->private_data)
> +		ep_free((struct eventpoll *) file->private_data);
>  

The old version was better, IMO.

You could just do

	if (file->private_data)
		ep_free(file->private_data);

but personally, I do like to see the purported type mentioned in there
somewhere.  But preferably not in a typecast.

Oh well.

