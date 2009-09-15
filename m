Return-Path: <linux-kernel-owner+w=401wt.eu-S1754545AbZIOOtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbZIOOtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 10:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495AbZIOOs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 10:48:56 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53108 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491AbZIOOsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 10:48:55 -0400
Message-ID: <4AAFA952.3050204@linux.vnet.ibm.com>
Date: Tue, 15 Sep 2009 09:48:50 -0500
From: Brian King <brking@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Nathan Fontenot <nfont@austin.ibm.com>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] kernel handling of CPU DLPAR
References: <4AAABC55.4070207@austin.ibm.com> <4AAABDF5.4090604@austin.ibm.com>
In-Reply-To: <4AAABDF5.4090604@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathan Fontenot wrote:
> +static ssize_t cpu_probe_store(struct class *class, const char *buf,
> +                   size_t count)
> +{
> +    struct device_node *dn;
> +    u32 drc_index;
> +    char *cpu_name;
> +    int rc;
> +
> +    drc_index = simple_strtoull(buf, NULL, 0);

Can just use simple_strtoul here instead.

> +    if (!drc_index)
> +        return -EINVAL;
> +
> +    rc = acquire_drc(drc_index);
> +    if (rc)
> +        return rc;
> +
> +    dn = configure_connector(drc_index);
> +    if (!dn) {
> +        release_drc(drc_index);
> +        return rc;
> +    }
> +
> +    /* fixup dn name */
> +    cpu_name = kzalloc(strlen(dn->full_name) + strlen("/cpus/") + 1,
> +               GFP_KERNEL);
> +    sprintf(cpu_name, "/cpus/%s", dn->full_name);
> +    kfree(dn->full_name);
> +    dn->full_name = cpu_name;
> +
> +    rc = add_device_tree_nodes(dn);
> +    if (rc)
> +        release_drc(drc_index);
> +
> +    return rc ? rc : count;
> +}
> +


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


