Return-Path: <linux-kernel-owner+w=401wt.eu-S1759737AbYGQPpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759737AbYGQPpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 11:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755178AbYGQPox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 11:44:53 -0400
Received: from mail.vyatta.com ([216.93.170.194]:53657 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052AbYGQPow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 11:44:52 -0400
X-Spam-Flag: NO
X-Spam-Score: -1.666
Date: Thu, 17 Jul 2008 08:44:50 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: <jie.yang@atheros.com>
Cc: <jeff@garzik.org>, <yjwei@cn.fujitsu.com>, <rdreier@cisco.com>,
       <davem@davemloft.net>, <jcliburn@gmail.com>, <parag.warudkar@gmail.com>,
       <w@1wt.eu>, <oliver.schuster@schweigstill.de>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] atl1e: Atheros L1E Gigabit Ethernet driver
Message-ID: <20080717084450.42ceca96@extreme>
In-Reply-To: <12162854952457-git-send-email-jie.yang@atheros.com>
References: <12162854952457-git-send-email-jie.yang@atheros.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +/*
> + * atl1e_check_options - Range Checking for Command Line Parameters
> + * @adapter: board private structure
> + *
> + * This routine checks all command line parameters for valid user
> + * input.  If an invalid value is given, or if no user specified
> + * value exists, a default value is used.  The final value is stored
> + * in a variable in the adapter structure.
> + */
> +void __devinit atl1e_check_options(struct atl1e_adapter *adapter)
> +{
> +	struct pci_dev *pdev = adapter->pdev;
> +	int bd = adapter->bd_number;
> +	if (bd >= ATL1E_MAX_NIC) {
> +		dev_notice(&pdev->dev, "no configuration for board #%i\n", bd);
> +		dev_notice(&pdev->dev, "Using defaults for all values\n");
> +	}


The use of module parameters to set options is discouraged, especially
when there are better choices. All these parameter should be controllable by ethtool.
The reason is that users (and tools) shouldn't have to know the
special parameters that are specific to that hardware.

This version is okay as is for initial inclusion, but the parameters should
be removed later.
