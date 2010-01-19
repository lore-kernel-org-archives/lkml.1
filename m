Return-Path: <linux-kernel-owner+w=401wt.eu-S1753673Ab0ASVs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab0ASVs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 16:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681Ab0ASVs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 16:48:26 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:7815 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab0ASVsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 16:48:25 -0500
Date: Tue, 19 Jan 2010 14:48:23 -0700
From: Alex Chiang <achiang@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 05/11] pci: update bridge res to get more big range in
	pci assign unssign
Message-ID: <20100119214823.GH11010@ldl.fc.hp.com>
References: <1263640037-24134-1-git-send-email-yinghai@kernel.org> <1263640037-24134-6-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263640037-24134-6-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	/* retore size and flags */

"restore"

> +	for (list = head.next; list;) {
> +		struct resource *res = list->res;
> +
> +		res->start = list->start;
> +		res->end = list->end;
> +		res->flags = list->flags;
> +		if (list->dev->subordinate)
> +			res->flags = 0;
> +
> +		list = list->next;
> +	}
> +	free_failed_list(&head);
> +
> +	goto again;
> +
> +enable_and_dump:
> +	/* Depth last, update the hardware. */
> +	list_for_each_entry(bus, &pci_root_buses, node) {
>  		pci_enable_bridges(bus);
>  	}

Strictly speaking, you don't need these curly braces.

/ac

