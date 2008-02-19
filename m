Return-Path: <linux-kernel-owner+w=401wt.eu-S1758189AbYBSTIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189AbYBSTIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbYBSTIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:08:40 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:2237 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbYBSTIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:08:39 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Subject: Re: TG3 network data corruption regression 2.6.24/2.6.23.4
From: "Michael Chan" <mchan@broadcom.com>
To: "Tony Battersby" <tonyb@cybernetics.com>
cc: "David Miller" <davem@davemloft.net>, herbert@gondor.apana.org.au,
       netdev <netdev@vger.kernel.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <47BB00EC.3010607@cybernetics.com>
References: <47BA0984.2070306@cybernetics.com>
 <1203381120.13495.78.camel@dell>
 <20080218.163554.74130592.davem@davemloft.net>
 <1203383046.13495.87.camel@dell> <47BB00EC.3010607@cybernetics.com>
Date: Tue, 19 Feb 2008 11:11:05 -0800
Message-ID: <1203448265.13495.95.camel@dell>
MIME-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8)
X-WSS-ID: 6BA5F6A53ZO5572808-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-19 at 11:16 -0500, Tony Battersby wrote:
> iSCSI
> performance drops to 6 - 15 MB/s when the 3Com NIC is doing heavy rx
> with light tx,

That's strange.  The patch should only affect TX performance slightly
since we are just turning off SG for TX.  Please take an ethereal trace
to see what's happening and compare with a good trace.

> but remains at a decent 115 MB/s when the 3Com NIC is
> doing heavy tx with light rx.  When I revert Herbert's patch instead
> of
> applying the patch above, I get 115 MB/s in both cases.  (With a stock
> unpatched kernel, the test fails almost immediately because the iSCSI
> control PDUs are corrupted, causing the TCP connection to be dropped.)
> 
> The SysKonnect NIC that does not exhibit this problem has a chip that
> says "BCM5411KQM" "TT0128 P2Q" and "56975E".
> 

I think this is the 5700, but please send me the tg3 output that
identifies the chip and the revision.  Something like this:

eth2: Tigon3 [partno(BCM95705) rev 3003 PHY(5705)] (PCI:66MHz:32-bit) 10/100/1000Base-T Ethernet 00:10:18:04:57:0d
eth2: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[0] TSOcap[1]





