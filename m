Return-Path: <linux-kernel-owner+w=401wt.eu-S1764854AbXHKTQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764854AbXHKTQM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 15:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762070AbXHKTP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 15:15:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36520 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760377AbXHKTPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 15:15:55 -0400
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
From: Arjan van de Ven <arjan@infradead.org>
To: casey@schaufler-ca.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@osdl.org, torvalds@osdl.org
In-Reply-To: <46BDF88B.2060301@schaufler-ca.com>
References: <46BDF88B.2060301@schaufler-ca.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Sat, 11 Aug 2007 12:12:53 -0700
Message-Id: <1186859573.2854.14.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 (2.11.6.1-1.fc8) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +extern struct smk_list_entry *smack_list;

any reason to invent your own list rather than just using list.h?



> +
> +#include <linux/kernel.h>
> +#include <linux/vmalloc.h>
> +#include <linux/security.h>
> +#include <linux/mutex.h>
> +#include <net/netlabel.h>
> +#include "../../net/netlabel/netlabel_domainhash.h"

can't you move this header to include/ instead?



> +
> +static struct file_operations smk_load_ops = {
> +	.read		= smk_read_load,
> +	.write		= smk_write_load,
> +};

make that a const please

> +
> +	doip = kmalloc(sizeof(struct cipso_v4_doi), GFP_KERNEL);
> +	if (doip == NULL)
> +		panic("smack:  Failed to initialize cipso DOI.\n");
> +	doip->map.std = NULL;
> +
> +	ndmp = kmalloc(sizeof(struct netlbl_dom_map), GFP_KERNEL);
> +	if (ndmp == NULL)
> +		panic("smack:  Failed to initialize cipso ndmp.\n");


is panic() really the right thing here? It's usually considered quite
rude ;)


> +static struct file_operations smk_cipso_ops = {
> +	.read		= smk_read_cipso,
> +	.write		= smk_write_cipso,
> +};

another candidate for const


> +static void *smackfs_follow_link(struct dentry *dentry, struct nameidata *nd)
> +{


this one deserves a comment; are you implementing magic symlinks here?



