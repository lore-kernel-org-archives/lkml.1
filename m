Return-Path: <linux-kernel-owner+w=401wt.eu-S1161024AbXDQRNF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161024AbXDQRNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 13:13:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161039AbXDQRNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 13:13:04 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:36106 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161024AbXDQRNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 13:13:02 -0400
Date: Tue, 17 Apr 2007 10:11:44 -0700
From: Zach Brown <zach.brown@oracle.com>
To: Pavel Emelianov <xemul@sw.ru>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH] Introduce a handy list_first_entry macro
Message-ID: <20070417171144.GR17395@mami.zabbo.net>
References: <4624AD20.6050009@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4624AD20.6050009@sw.ru>
User-Agent: Mutt/1.4.2.1i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 03:18:56PM +0400, Pavel Emelianov wrote:
> There are many places in the kernel where the construction like
> 
>    foo = list_entry(head->next, struct foo_struct, list);
> 
> are used. 
> The code might look more descriptive and neat if using the macro
> 
>    list_first_entry(head, type, member) \
>              list_entry((head)->next, type, member)

> -			dquot = list_entry(dirty->next, struct dquot, dq_dirty);
> +			dquot = list_first_entry(dirty, struct dquot, dq_dirty);

I think it's more than just descriptive and neat.  A common sneaky bug
is to accidentally pass &list->next into list_entry() instead of
list->next. This is easy to do because one is used to typing &list in
list_empty(), etc.  So by following ->next in the macro we make the list
argument consistent in list_empty() and list_first_entry() and hopefully
reduce the risk of making that mistake.

I like it.

- z
