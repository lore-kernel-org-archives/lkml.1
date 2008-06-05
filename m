Return-Path: <linux-kernel-owner+w=401wt.eu-S1758764AbYFEO5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbYFEO5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 10:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbYFEO4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 10:56:50 -0400
Received: from zux006-004-203.adsl.green.ch ([81.6.4.203]:36656 "EHLO
	mailx.swiss-it.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbYFEO4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 10:56:50 -0400
Message-ID: <4847FF29.20500@swiss-it.ch>
Date: Thu, 05 Jun 2008 16:58:49 +0200
From: =?UTF-8?B?QWRyaWFuLUtlbiBSw7xlZ3NlZ2dlcg==?= 
	<rueegsegger@swiss-it.ch>
Organization: secunet SwissIT AG
User-Agent: Icedove 1.5.0.14eol (X11/20080509)
MIME-Version: 1.0
To: Martin Willi <martin@strongswan.org>
CC: herbert@gondor.apana.org.au, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.26rc5] xfrm: SHA-256/384/512 HMAC support for IPsec
References: <1212671211.6339.58.camel@martin> <4847F310.7020207@swiss-it.ch> <1212677101.6339.75.camel@martin>
In-Reply-To: <1212677101.6339.75.camel@martin>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Willi wrote:
>> You could register a new SADB algorithm id in pfkeyv2.h and add a new
>> entry to the aalg_list analogous to how GCM is doing that in the aead_list.
>>
>> Adrian
> 
> We could do that, but ﻿SADB_X_AALG_SHA2_256HMAC (5) actually refers to
> 128 bit truncation. 96 bit truncation is a leftover of
> draft-ietf-ipsec-ciph-sha-256-00 and has been replaced by 128 bit
> truncation in draft-ietf-ipsec-ciph-sha-256-01. 
> 
> d﻿raft-kelly-ipsec-ciph-sha2 and the resulting RFC4868 define 128 bit
> truncation for ﻿SADB_X_AALG_SHA2_256HMAC (5), so 96 bit truncation is
> really obsolete. We could define a new PF_KEY algorithm for 96 bit
> truncation, but it is not really usable as it is not standardized.

I agree that 96bit truncation is obsolete and 128 bit should be used.
However people might be using the current implementation and this patch
could cause trouble for them. The question is if anybody really depends
on the current behavior.

Adrian
