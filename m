Return-Path: <linux-kernel-owner+w=401wt.eu-S1752106AbYH2CHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbYH2CHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 22:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbYH2CH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 22:07:27 -0400
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3165 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbYH2CHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 22:07:24 -0400
Date: Fri, 29 Aug 2008 04:07:21 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Eric Sesterhenn <snakebyte@gmx.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch] Check hfs_bnode_find return value
In-Reply-To: <20080826172332.GA22058@alice>
Message-ID: <Pine.LNX.4.64.0808290405480.2507@localhost.localdomain>
References: <20080826172332.GA22058@alice>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 26 Aug 2008, Eric Sesterhenn wrote:

> --- linux/fs/hfsplus/brec.c.orig	2008-08-26 19:18:56.000000000 +0200
> +++ linux/fs/hfsplus/brec.c	2008-08-26 19:19:27.000000000 +0200
> @@ -304,6 +304,8 @@ static struct hfs_bnode *hfs_bnode_split
>  	/* update next bnode header */
>  	if (new_node->next) {
>  		struct hfs_bnode *next_node = hfs_bnode_find(tree, new_node->next);
> +		if (IS_ERR(next_node))
> +			return next_node;
>  		next_node->prev = new_node->this;
>  		hfs_bnode_read(next_node, &node_desc, 0, sizeof(node_desc));
>  		node_desc.prev = cpu_to_be32(next_node->prev);

Al Viro already fixed this for HFS in a better way, could you please adopt 
his solution?

bye, Roman
