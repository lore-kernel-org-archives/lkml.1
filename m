Return-Path: <linux-kernel-owner+w=401wt.eu-S938270AbYCSVnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938270AbYCSVnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758462AbYCSUMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:12:17 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37216 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764766AbYCSUMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:12:16 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 19 Mar 2008 21:11:16 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 1/2] firewire: catch self_id_count == 0
To: Jarod Wilson <jwilson@redhat.com>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.b99824b37365e037@s5r6.in-berlin.de>
Message-ID: <tkrat.b8cbad37fe2bba7b@s5r6.in-berlin.de>
References: <tkrat.b99824b37365e037@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> --- linux.orig/drivers/firewire/fw-topology.c
> +++ linux/drivers/firewire/fw-topology.c
> @@ -513,6 +513,11 @@ fw_core_handle_bus_reset(struct fw_card 
>  
>  	fw_flush_transactions(card);
>  
> +	if (self_id_count == 0) {
> +		fw_destroy_nodes(card);
> +		return;
> +	}

We may also want to update some other card-> members, pull the topology
map down, and whatnot...
-- 
Stefan Richter
-=====-==--- --== =--==
http://arcgraph.de/sr/


