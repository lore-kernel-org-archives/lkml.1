Return-Path: <linux-kernel-owner+w=401wt.eu-S932434AbZAPKdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434AbZAPKdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 05:33:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758951AbZAPKdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 05:33:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42382 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757462AbZAPKdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 05:33:03 -0500
Date: Fri, 16 Jan 2009 11:32:09 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       Dhananjay Phadke <dhananjay@netxen.com>
Subject: [build bug] drivers/net/netxen/netxen_nic_main.c:1189: error:
	implicit declaration of function 'ipv6_hdr'
Message-ID: <20090116103209.GA9122@elte.hu>
References: <20090115.160159.262623707.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090115.160159.262623707.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

>       netxen: fix endianness in firmware commands
>       netxen: fix ipv6 offload and tx cleanup
>       netxen: fix link speed reporting for some boards
>       netxen: firmware init fix
>       netxen: cleanup mac list on driver unload
>       netxen: hold tx lock while sending firmware commands
>       netxen: handle dma mapping failures

One of these causes frequent build failures on x86, on today's -git:

 drivers/net/netxen/netxen_nic_main.c:1189: error: implicit declaration of function 'ipv6_hdr'
 drivers/net/netxen/netxen_nic_main.c:1189: error: invalid type argument of '->'

i suspect the key aspect is:

# CONFIG_IPV6 is not set

	Ingo
