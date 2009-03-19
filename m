Return-Path: <linux-kernel-owner+w=401wt.eu-S1758740AbZCSJlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740AbZCSJlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 05:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbZCSJl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 05:41:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754446AbZCSJlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 05:41:25 -0400
Date: Thu, 19 Mar 2009 02:34:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Chiang <achiang@hp.com>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH v4 07/12] PCI: Introduce /sys/bus/pci/rescan
Message-Id: <20090319023453.7467644a.akpm@linux-foundation.org>
In-Reply-To: <20090318224001.887.63554.stgit@bob.kio>
References: <20090318222426.887.1008.stgit@bob.kio>
	<20090318224001.887.63554.stgit@bob.kio>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Mar 2009 16:40:01 -0600 Alex Chiang <achiang@hp.com> wrote:

> +#ifdef CONFIG_HOTPLUG
> +static DEFINE_MUTEX(pci_remove_rescan_mutex);
> +static ssize_t bus_rescan_store(struct bus_type *bus, const char *buf,
> +				size_t count)
> +{
> +	unsigned long val;
> +	struct pci_bus *b = NULL;
> +
> +	if (strict_strtoul(buf, 0, &val) < 0)
> +		return -EINVAL;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	if (val) {
> +		mutex_lock(&pci_remove_rescan_mutex);
> +		while ((b = pci_find_next_bus(b)) != NULL)
> +			pci_rescan_bus(b);
> +		mutex_unlock(&pci_remove_rescan_mutex);
> +	}
> +	return count;
> +}
> +
> +struct bus_attribute pci_bus_attrs[] = {
> +	__ATTR(rescan, S_IWUSR, NULL, bus_rescan_store),
> +	__ATTR_NULL
> +};
> +#endif

Why CONFIG_HOTPLUG rather than CONFIG_HOTPLUG_PCI (or similar)?
