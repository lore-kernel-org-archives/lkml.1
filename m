Return-Path: <linux-kernel-owner+w=401wt.eu-S1761421AbXHKT4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761421AbXHKT4x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 15:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752560AbXHKT4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 15:56:45 -0400
Received: from web36607.mail.mud.yahoo.com ([209.191.85.24]:26616 "HELO
	web36607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752353AbXHKT4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 15:56:44 -0400
X-YMail-OSG: ED_bE_sVM1locp5JXL41O19OyCceJqgpxEQTfbEA48qWug2ahhd2zrPb1ripboHxq3Iq6k67tw--
X-RocketYMMF: rancidfat
Date: Sat, 11 Aug 2007 12:56:42 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH] Smack: Simplified Mandatory Access Control Kernel
To: Arjan van de Ven <arjan@infradead.org>, casey@schaufler-ca.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@osdl.org, torvalds@osdl.org
In-Reply-To: <1186859573.2854.14.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <939644.96168.qm@web36607.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Arjan van de Ven <arjan@infradead.org> wrote:

> > +extern struct smk_list_entry *smack_list;
> 
> any reason to invent your own list rather than just using list.h?

The list.h mechanisms are fine, but heavier than I require.
I'm willing to give in on it, but I don't see an advantage.

> > +
> > +#include <linux/kernel.h>
> > +#include <linux/vmalloc.h>
> > +#include <linux/security.h>
> > +#include <linux/mutex.h>
> > +#include <net/netlabel.h>
> > +#include "../../net/netlabel/netlabel_domainhash.h"
> 
> can't you move this header to include/ instead?

Paul Moore, the developer of netlabel, promised to work out
the right solution for this with me at a future date. He
doesn't want to move the header, and I respect that.

> > +
> > +static struct file_operations smk_load_ops = {
> > +	.read		= smk_read_load,
> > +	.write		= smk_write_load,
> > +};
> 
> make that a const please

Will do.

> > +
> > +	doip = kmalloc(sizeof(struct cipso_v4_doi), GFP_KERNEL);
> > +	if (doip == NULL)
> > +		panic("smack:  Failed to initialize cipso DOI.\n");
> > +	doip->map.std = NULL;
> > +
> > +	ndmp = kmalloc(sizeof(struct netlbl_dom_map), GFP_KERNEL);
> > +	if (ndmp == NULL)
> > +		panic("smack:  Failed to initialize cipso ndmp.\n");
> 
> 
> is panic() really the right thing here? It's usually considered quite
> rude ;)

It's really early in start-up and if you're out of memory at that
point you are not going very far into the future.

> > +static struct file_operations smk_cipso_ops = {
> > +	.read		= smk_read_cipso,
> > +	.write		= smk_write_cipso,
> > +};
> 
> another candidate for const

Will do that, too.

> > +static void *smackfs_follow_link(struct dentry *dentry, struct nameidata
> *nd)
> > +{
> 
> 
> this one deserves a comment; are you implementing magic symlinks here?

Yup.

Casey Schaufler
casey@schaufler-ca.com
