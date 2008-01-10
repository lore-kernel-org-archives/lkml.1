Return-Path: <linux-kernel-owner+w=401wt.eu-S1760648AbYAJTKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760648AbYAJTKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 14:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757333AbYAJTKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 14:10:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:40168 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755611AbYAJTKh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 14:10:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,267,1196668800"; 
   d="scan'208";a="251987758"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [ipw3945-devel] [PATCH 2/5] iwlwifi: iwl3945 synchronize interruptand tasklet for down iwlwifi
Date: Thu, 10 Jan 2008 11:10:35 -0800
Message-ID: <D936D925018D154694D8A362EEB08920035CCD70@orsmsx416.amr.corp.intel.com>
In-Reply-To: <11998765481610-git-send-email-joonwpark81@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [ipw3945-devel] [PATCH 2/5] iwlwifi: iwl3945 synchronize interruptand tasklet for down iwlwifi
Thread-Index: AchSr1Tb9X0Zp5WrRni6XeMZcn58UQBDJ55g
References: <11998765481610-git-send-email-joonwpark81@gmail.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Joonwoo Park" <joonwpark81@gmail.com>, "Zhu, Yi" <yi.zhu@intel.com>,
       <netdev@vger.kernel.org>
Cc: <linux-wireless@vger.kernel.org>, "lkml" <linux-kernel@vger.kernel.org>,
       <ipw3945-devel@lists.sourceforge.net>
X-OriginalArrivalTime: 10 Jan 2008 19:10:35.0888 (UTC) FILETIME=[7AC70700:01C853BC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On , Joonwoo Park  wrote:

> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -6262,6 +6262,10 @@ static void __iwl_down(struct iwl_priv *priv)
> 	/* tell the device to stop sending interrupts */
> 	iwl_disable_interrupts(priv);
> 
> +	/* synchronize irq and tasklet */
> +	synchronize_irq(priv->pci_dev->irq);
> +	tasklet_kill(&priv->irq_tasklet);
> +

Could synchronize_irq() be moved into iwl_disable_interrupts() ? I am
also wondering if we cannot call tasklet_kill() before
iwl_disable_interrupts() ... thus preventing it from being scheduled
when we are going down. 

Reinette
