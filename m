Return-Path: <linux-kernel-owner+w=401wt.eu-S1765390AbYBTP2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765390AbYBTP2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 10:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764370AbYBTPUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 10:20:10 -0500
Received: from host64.cybernetics.com ([70.169.137.4]:2419 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbYBTPS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 10:18:59 -0500
Message-ID: <47BC44E2.9060301@cybernetics.com>
Date: Wed, 20 Feb 2008 10:18:58 -0500
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Michael Chan <mchan@broadcom.com>, David Miller <davem@davemloft.net>,
       netdev <netdev@vger.kernel.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: TG3 network data corruption regression 2.6.24/2.6.23.4
References: <47BA0984.2070306@cybernetics.com> <1203381120.13495.78.camel@dell> <20080218.163554.74130592.davem@davemloft.net> <1203383046.13495.87.camel@dell> <47BB00EC.3010607@cybernetics.com> <1203448265.13495.95.camel@dell> <47BB54C2.6090501@cybernetics.com> <20080220034515.GC22703@gondor.apana.org.au>
In-Reply-To: <20080220034515.GC22703@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> On Tue, Feb 19, 2008 at 05:14:26PM -0500, Tony Battersby wrote:
>   
>> Update: when I revert Herbert's patch in addition to applying your
>> patch, the iSCSI performance goes back up to 115 MB/s again in both
>> directions.  So it looks like turning off SG for TX didn't itself cause
>> the performance drop, but rather that the performance drop is just
>> another manifestation of whatever bug is causing the data corruption.
>>     
>
> Interesting.  So the workload that regressed is mostly RX with a
> little TX traffic? Can you try to reproduce this with something
> like netperf to eliminate other variables?
>
> This is all very puzzling since the patch in question shouldn't
> change an RX load at all.
>
> Thanks,
>   
We have established that the slowdown was caused by TCP checksum errors
and retransmits.  I assume that the slowdown in my test was due to the
light TX rather than the heavy RX.  I am no TCP protocol expert, but
perhaps heavy TX (such as iperf) might not be affected as much because
the wire stays busy while waiting for the retransmit, whereas with my
light TX iSCSI load, the wire goes idle while waiting for the retransmit
because the iSCSI state machine is stalled.

Tony

