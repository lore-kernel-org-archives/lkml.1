Return-Path: <linux-kernel-owner+w=401wt.eu-S1756414Ab0AMVNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414Ab0AMVNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 16:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318Ab0AMVNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 16:13:50 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:45458 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416Ab0AMVNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 16:13:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iCBOkzwsV8hI3GYYegZ/BUFr0yCnXzB7v6Yrt1Zz9ptL/MSrHpGDEdzKXiJJdwOsNs
         Rm0r8M7XI/d+Sg2mh/67IKa7kIGghm2W9gknGawd0+6meYl2ELky7o483pF4nY3hZ0yd
         3dMYRWvCjagizjL2fHXP62Rey3fOzPyFawVvM=
Message-ID: <4B4E378A.7040506@gmail.com>
Date: Wed, 13 Jan 2010 16:13:46 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v4] tcp: harmonize tcp_vx_rcv header length assumptions
References: <4B49D001.4000302@gmail.com> <4B4DA4F4.6060007@gmail.com> <20100113115617.GA24818@basil.fritz.box> <4B4DE887.6030602@gmail.com> <20100113155323.GB24818@basil.fritz.box> <4B4E23E0.4000007@gmail.com>
In-Reply-To: <4B4E23E0.4000007@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I did today's tests on tcp_ipv4, but part of this harmonization is to
make v4 and v6 match up better.  As I was examining line by line, one of
the things that leaps out is that ipv4 has nf_reset(skb):

tcp_ipv4:
	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb))
		goto discard_and_relse;
	nf_reset(skb);

	if (sk_filter(sk, skb))
		goto discard_and_relse;

tcp_ipv6:
	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb))
		goto discard_and_relse;

	if (sk_filter(sk, skb))
		goto discard_and_relse;

Does anybody know why?  Should ipv6 have it?  Or at least a comment
explaining the reasoning for the omission?


