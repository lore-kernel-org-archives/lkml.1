Return-Path: <linux-kernel-owner+w=401wt.eu-S933900AbZKYDWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933900AbZKYDWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 22:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932732AbZKYDWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 22:22:47 -0500
Received: from ozlabs.org ([203.10.76.45]:32889 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932977AbZKYDWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 22:22:46 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19212.41387.37749.652776@cargo.ozlabs.ibm.com>
Date: Wed, 25 Nov 2009 14:16:59 +1100
From: Paul Mackerras <paulus@samba.org>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Kernel DLPAR infrastructure
In-Reply-To: <4B0C8CE3.4010207@austin.ibm.com>
References: <4B0C8B45.6080804@austin.ibm.com>
	<4B0C8CE3.4010207@austin.ibm.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathan Fontenot writes:

> This patch provides the kernel DLPAR infrastructure in a new filed named
> dlpar.c.  The functionality provided is for acquiring and releasing a resource
> from firmware and the parsing of information returned from the
> ibm,configure-connector rtas call.  Additionally this exports the pSeries
> reconfiguration notifier chain so that it can be invoked when device tree 
> updates are made.

Mostly looks great.

> +static struct device_node *derive_parent(const char *path)
> +{
> +	struct device_node *parent;
> +	char parent_path[128];
> +	int parent_path_len;
> +
> +	parent_path_len = strrchr(path, '/') - path + 1;
> +	strlcpy(parent_path, path, parent_path_len);

This looks a bit fragile if path could possibly not contain any '/' or
if the '/' is more than 128 characters from the start of path.  Please
fix this to check if strrchr returns NULL and to cope in some
reasonable fashion if the path happens to be very long.

> +#ifdef CONFIG_PROC_DEVICETREE
> +	ent = proc_mkdir(strrchr(dn->full_name, '/') + 1, dn->parent->pde);
> +	if (ent)
> +		proc_device_tree_add_node(dn, ent);

Also assumes that dn->full_name contains a '/'.  If for some reason it
couldn't possibly not contain a '/', put in a comment explaining that.

Thanks,
Paul.
