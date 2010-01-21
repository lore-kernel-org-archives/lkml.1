Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695Ab0AUUmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab0AUUmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 15:42:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932Ab0AUUmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 15:42:05 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:9132 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab0AUUmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 15:42:01 -0500
Date: Thu, 21 Jan 2010 13:41:59 -0700
From: Alex Chiang <achiang@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/9] pci: add failed_list to record failed one for
	pci_bus_assign_resources
Message-ID: <20100121204159.GE17684@ldl.fc.hp.com>
References: <1264054456-12694-1-git-send-email-yinghai@kernel.org> <1264054456-12694-3-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264054456-12694-3-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More bike shedding.

* Yinghai Lu <yinghai@kernel.org>:
> @@ -58,6 +103,13 @@ static void pbus_assign_resources_sorted(const struct pci_bus *bus)
>  		res = list->res;
>  		idx = res - &list->dev->resource[0];
>  		if (pci_assign_resource(list->dev, idx)) {
> +			if (fail_head && !pci_is_root_bus(list->dev->bus)) {
> +				/*
> +				 * device need to keep flags and size
> +				 * for next try
> +				 */
> +				add_to_failed_list(fail_head, list->dev, res);
> +			}

I don't really think you need that comment, so just strike it
completely and drop the curly braces.


			if (fail_head && !pci_is_root_bus(list->dev->bus))
				add_to_failed_list(fail_head, list->dev, res);

Reviewed-by: Alex Chiang <achiang@hp.com>

/ac

