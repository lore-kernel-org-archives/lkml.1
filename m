Return-Path: <linux-kernel-owner+w=401wt.eu-S1758864AbYLLOaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864AbYLLOaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 09:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757727AbYLLO36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 09:29:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:45691 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757611AbYLLO35 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 09:29:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,211,1228118400"; 
   d="scan'208";a="413924476"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "hskinnemoen@atmel.com" <hskinnemoen@atmel.com>,
       "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
       "nicolas.ferre@atmel.com" <nicolas.ferre@atmel.com>
Date: Fri, 12 Dec 2008 14:29:47 +0000
Subject: RE: [PATCH 11/13] dmaengine: kill struct dma_client and supporting
	infrastructure
Thread-Topic: [PATCH 11/13] dmaengine: kill struct dma_client and supporting
	infrastructure
Thread-Index: AclGoOZ9zvcnEEP+S6uSxyiNxGC4SwVvpWmg
Message-ID: <129600E5E5FB004392DDC3FB599660D70C8F3407@irsmsx504.ger.corp.intel.com>
References: <20081114213300.32354.1154.stgit@dwillia2-linux.ch.intel.com>
 <20081114213513.32354.58256.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20081114213513.32354.58256.stgit@dwillia2-linux.ch.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Williams, Dan J wrote:
> All users have been converted to either the general-purpose allocator,
> dma_find_channel, or dma_request_channel.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
(...)
>  /**
> - * dma_chans_notify_available - broadcast available channels to the
> clients 
> - */
> -static void dma_clients_notify_available(void)
> -{
> -	struct dma_client *client;
> -
> -	mutex_lock(&dma_list_mutex);
> -
> -	list_for_each_entry(client, &dma_client_list, global_node)
> -		dma_client_chan_alloc(client);
> -
> -	mutex_unlock(&dma_list_mutex);
> -}

I agree with Guennadi's concern about removing clients' notification
of new devices available in the system.
I understand that this design is based on polling instead,
however polling is always less efficient approach.
Do you think that restoring notifications in this redesigned dmaengine
would be more painful than limiting clients to polling solution?

Regards,
Maciej