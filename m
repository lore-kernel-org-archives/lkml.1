Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478Ab0ADRSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab0ADRSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 12:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219Ab0ADRSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 12:18:53 -0500
Received: from outbound-mail-31.bluehost.com ([69.89.18.151]:46862 "HELO
	outbound-mail-31.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751551Ab0ADRSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 12:18:52 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=XhrWJnYbAbDp5cPzCN+rNaZjQvGtyi5wq4OjGnI9zxeU4YstQnGDD2InypM9X1uqIMB+clHg3GXI4UM8Tn/P66DJmIo0hS9FWU8WVxafVlmMtkhHmlUTgeYKiUqVGldd;
Date: Mon, 4 Jan 2010 09:18:49 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: David John <davidjon@xenontk.org>
Cc: rusty@rustcorp.com.au, andreas.herrmann3@amd.com, rjw@sisk.pl,
       jin.dongming@np.css.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Check the node argument passed to cpumask_of_node
Message-ID: <20100104091849.58d85bae@jbarnes-piketon>
In-Reply-To: <1262617137-3321-1-BlackWidow-davidjon@xenontk.org>
References: <4B41D42A.9040008@xenontk.org>
	<1262617137-3321-1-BlackWidow-davidjon@xenontk.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  4 Jan 2010 20:28:57 +0530
David John <davidjon@xenontk.org> wrote:

> Commit e0cd516 "PCI: derive nearby CPUs from device's instead of bus'
> NUMA information" causes an null pointer dereference when reading
> from the sysfs attributes local_cpu* on Intel machines with no ACPI
> NUMA proximity info, since dev->numa_node gets set to -1 for all PCI
> devices, which then gets passed to cpumask_of_node.
> 
> Add a check to prevent this.
> 
> Signed-off-by: David John <davidjon@xenontk.org>
> 
> diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
> index c5df94e..807224e 100644
> --- a/drivers/pci/pci-sysfs.c
> +++ b/drivers/pci/pci-sysfs.c
> @@ -75,7 +75,8 @@ static ssize_t local_cpus_show(struct device *dev,
>  	int len;
>  
>  #ifdef CONFIG_NUMA
> -	mask = cpumask_of_node(dev_to_node(dev));
> +	mask = (dev_to_node(dev) == -1) ? cpu_online_mask :
> +
> cpumask_of_node(dev_to_node(dev)); #else
>  	mask = cpumask_of_pcibus(to_pci_dev(dev)->bus);
>  #endif
> @@ -93,7 +94,8 @@ static ssize_t local_cpulist_show(struct device
> *dev, int len;
>  
>  #ifdef CONFIG_NUMA
> -	mask = cpumask_of_node(dev_to_node(dev));
> +	mask = (dev_to_node(dev) == -1) ? cpu_online_mask :
> +
> cpumask_of_node(dev_to_node(dev)); #else
>  	mask = cpumask_of_pcibus(to_pci_dev(dev)->bus);
>  #endif
> 

Applied to my for-linus branch, thanks David.

-- 
Jesse Barnes, Intel Open Source Technology Center
