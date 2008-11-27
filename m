Return-Path: <linux-kernel-owner+w=401wt.eu-S1752659AbYK0PGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbYK0PGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 10:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbYK0PF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 10:05:59 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42035 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbYK0PF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 10:05:59 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0811271524340.15160@pc-004.diku.dk>
References: <Pine.LNX.4.64.0811271524340.15160@pc-004.diku.dk>
To: Julia Lawall <julia@diku.dk>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] arch/frv/kernel/sys_frv.c: add missing fput
Date: Thu, 27 Nov 2008 15:05:52 +0000
Message-ID: <9512.1227798352@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <julia@diku.dk> wrote:

> -	if (pgoff & ((1<<(PAGE_SHIFT-12))-1))
> -		return -EINVAL;
> +	if (pgoff & ((1<<(PAGE_SHIFT-12))-1)) {
> +		error = -EINVAL;
> +		goto out_file;
> +	}

There's a better way to fix this.  The check on pgoff should be done before
fget() is called.

David
