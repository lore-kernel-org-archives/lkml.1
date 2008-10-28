Return-Path: <linux-kernel-owner+w=401wt.eu-S1753458AbYJ1RUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbYJ1RUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYJ1RUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:20:36 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:28641 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbYJ1RUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:20:35 -0400
Message-ID: <49074A63.1090105@colorfullife.com>
Date: Tue, 28 Oct 2008 18:22:43 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Nadia.Derbey@bull.net
CC: cboulte@gmail.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SYSVIPC - Fix the ipc structures initialization
References: <20081028145952.620752409@bull.net> <20081028150041.857635775@bull.net>
In-Reply-To: <20081028150041.857635775@bull.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nadia.Derbey@bull.net wrote:
> Index: linux-2.6.27/ipc/util.c
> ===================================================================
> --- linux-2.6.27.orig/ipc/util.c	2008-10-23 15:20:46.000000000 +0200
> +++ linux-2.6.27/ipc/util.c	2008-10-28 16:52:17.000000000 +0100
> @@ -266,9 +266,17 @@ int ipc_addid(struct ipc_ids* ids, struc
>  	if (ids->in_use >= size)
>  		return -ENOSPC;
>  
> +	spin_lock_init(&new->lock);
> +	new->deleted = 0;
>   
Is "new->deleted = 0" still necessary?
Acquiring the lock should be sufficient.

--
    Manfred
