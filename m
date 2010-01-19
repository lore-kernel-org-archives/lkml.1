Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004Ab0ASJaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab0ASJaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 04:30:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939Ab0ASJaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 04:30:16 -0500
Received: from stinky.trash.net ([213.144.137.162]:41868 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423Ab0ASJaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 04:30:13 -0500
Message-ID: <4B557BA2.7080407@trash.net>
Date: Tue, 19 Jan 2010 10:30:10 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: William Allen Simpson <william.allen.simpson@gmail.com>
CC: Simon Arlott <simon@fire.lp0.eu>, netdev <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] xt_TCPMSS: SYN packets are allowed to contain data
References: <4B54CDE5.3070100@simon.arlott.org.uk> <4B5578A5.50705@gmail.com>
In-Reply-To: <4B5578A5.50705@gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

William Allen Simpson wrote:
> Simon Arlott wrote:
>> The check for data only needs to apply where the packet length
>> could be increased by adding the MSS option. (The MSS option
>> itself applies to the sender's maximum receive size which is
>> not relevant to any data in its own packet.)
>>
>> This moves the check for (header size != packet size) to after
>> attempting to modify an existing MSS option. Another check is
>> needed before looking through the header to ensure it doesn't
>> claim to be larger than the packet size.
>>
> What's the path from tcp_v[4,6]_rcv() to these tests?
> 
> 1) Header larger than the packet is already tested in about 5 places,
> and my patch "tcp: harmonize tcp_vx_rcv header length assumptions"
> tries to get them all down to just *one* test.

We're talking about a netfilter module here, which has to deal
with forwarded traffic and can only rely on the IP header checks
done in ip_rcv().
