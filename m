Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988Ab0ASMnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab0ASMnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 07:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395Ab0ASMnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 07:43:50 -0500
Received: from proxima.lp0.eu ([81.2.80.65]:36947 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751Ab0ASMnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 07:43:49 -0500
Message-ID: <a1c09459b273a62b96a5f3937a36a3f337d36bab@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
In-Reply-To: <4B557BA2.7080407@trash.net>
References: <4B54CDE5.3070100@simon.arlott.org.uk> <4B5578A5.50705@gmail.com>
    <4B557BA2.7080407@trash.net>
Date: Tue, 19 Jan 2010 12:43:46 -0000
Subject: Re: [PATCH] xt_TCPMSS: SYN packets are allowed to contain data
From: "Simon Arlott" <simon@fire.lp0.eu>
To: "Patrick McHardy" <kaber@trash.net>
Cc: "William Allen Simpson" <william.allen.simpson@gmail.com>,
       "netdev" <netdev@vger.kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Netfilter Development Mailinglist" <netfilter-devel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, January 19, 2010 09:30, Patrick McHardy wrote:
> William Allen Simpson wrote:
>> Simon Arlott wrote:
>>> This moves the check for (header size != packet size) to after
>>> attempting to modify an existing MSS option. Another check is
>>> needed before looking through the header to ensure it doesn't
>>> claim to be larger than the packet size.
>>>
>> What's the path from tcp_v[4,6]_rcv() to these tests?
>>
>> 1) Header larger than the packet is already tested in about 5 places,
>> and my patch "tcp: harmonize tcp_vx_rcv header length assumptions"
>> tries to get them all down to just *one* test.
>
> We're talking about a netfilter module here, which has to deal
> with forwarded traffic and can only rely on the IP header checks
> done in ip_rcv().

My gateway (where these error messages occur) is running 2.6.29,
and skb->len (from the prink) is 40 bytes.

If this is 20 (IPv4 Header) + 20 (TCP Header) = 40 bytes, then there
is no data and the header offset is wrong so it hasn't been checked.

-- 
Simon Arlott
