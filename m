Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbZCJUrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbZCJUrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 16:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbZCJUro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 16:47:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751741AbZCJUrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 16:47:43 -0400
Date: Tue, 10 Mar 2009 13:46:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harry Ciao <qingtao.cao@windriver.com>
Cc: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
Subject: Re: [v1 PATCH 3/8] EDAC: AMD8111 driver source file
Message-Id: <20090310134607.1915c53c.akpm@linux-foundation.org>
In-Reply-To: <1236586097-3830-4-git-send-email-qingtao.cao@windriver.com>
References: <1236586097-3830-1-git-send-email-qingtao.cao@windriver.com>
	<1236586097-3830-2-git-send-email-qingtao.cao@windriver.com>
	<1236586097-3830-3-git-send-email-qingtao.cao@windriver.com>
	<1236586097-3830-4-git-send-email-qingtao.cao@windriver.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  9 Mar 2009 16:08:12 +0800
Harry Ciao <qingtao.cao@windriver.com> wrote:

> Introduce AMD8111 EDAC driver source file, which makes use of error
> detections on the LPC Bridge Controller and PCI Bridge Controller on
> the AMD8111 HyperTransport I/O Hub.
> 
>
> ...
>
> +/* Wrapper functions for accessing PCI configuration space */
> +static int edac_pci_read_dword(struct pci_dev *dev, int reg, u32 *val32)
> +{
> +	int ret;
> +
> +	ret = pci_read_config_dword(dev, reg, val32);
> +	if (ret > 0)
> +		printk(KERN_ERR AMD8111_EDAC_MOD_STR
> +			" PCI Access Read Error at 0x%x\n", reg);
> +
> +	return ret;
> +}
>
> +static void edac_pci_read_byte(struct pci_dev *dev, int reg, u8 *val8)
> +{
> +	int ret;
> +
> +	ret = pci_read_config_byte(dev, reg, val8);
> +	if (ret > 0)
> +		printk(KERN_ERR AMD8111_EDAC_MOD_STR
> +			" PCI Access Read Error at 0x%x\n", reg);
> +}
> +
> +static void edac_pci_write_dword(struct pci_dev *dev, int reg, u32 val32)
> +{
> +	int ret;
> +
> +	ret = pci_write_config_dword(dev, reg, val32);
> +	if (ret > 0)
> +		printk(KERN_ERR AMD8111_EDAC_MOD_STR
> +			" PCI Access Write Error at 0x%x\n", reg);
> +}
> +
> +static void edac_pci_write_byte(struct pci_dev *dev, int reg, u8 val8)
> +{
> +	int ret;
> +
> +	ret = pci_write_config_byte(dev, reg, val8);
> +	if (ret > 0)
> +		printk(KERN_ERR AMD8111_EDAC_MOD_STR
> +			" PCI Access Write Error at 0x%x\n", reg);
> +}


<spends a while trying to work out what the return value of
pci_read_config_dword() means>

<gets frustrated and gives up>

Is it correct that all of these functions treat a +ve return value as
an error?

>
> ...
>
