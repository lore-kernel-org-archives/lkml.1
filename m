Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087AbYBMAFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbYBMAFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbYBMAFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:05:20 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34732 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752010AbYBMAFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:05:18 -0500
Date: Tue, 12 Feb 2008 16:04:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, ben@fluff.org, magnus.damm@gmail.com,
       linux-sh@vger.kernel.org
Subject: Re: [PATCH] sm501: Add uart support
Message-Id: <20080212160407.2e2f64ce.akpm@linux-foundation.org>
In-Reply-To: <20080208095742.2041.46016.sendpatchset@clockwork.opensource.se>
References: <20080208095742.2041.46016.sendpatchset@clockwork.opensource.se>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Feb 2008 18:57:42 +0900
Magnus Damm <magnus.damm@gmail.com> wrote:

>  	smdev = kzalloc(sizeof(struct sm501_device) +
> -			sizeof(struct resource) * res_count, GFP_KERNEL);
> +			(sizeof(struct resource) * res_count) +
> +			platform_data_size, GFP_KERNEL);
>
> ...
>
> +		smdev->pdev.resource = (struct resource *)(smdev+1);

So this driver plays party tricks with memory allocation and the C type
system.

We could at least add

	struct resource resources[0];

to the end of `struct sm501_device' to avoid the type abuse.  Or we could
even get radical and splurge four bytes on a `struct resource *'.  But
please, not this.


Oh well. A pre-existing problem.
