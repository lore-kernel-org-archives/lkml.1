Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbYFEOpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbYFEOpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 10:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755482AbYFEOp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 10:45:27 -0400
Received: from ns.km23152-01.keymachine.de ([87.118.114.125]:45302 "EHLO
	km23152-01.keymachine.de" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755439AbYFEOp0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 10:45:26 -0400
Subject: Re: [PATCH 2.6.26rc5] xfrm: SHA-256/384/512 HMAC support for IPsec
From: Martin Willi <martin@strongswan.org>
To: Adrian-Ken =?ISO-8859-1?Q?R=FCegsegger?= <rueegsegger@swiss-it.ch>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <4847F310.7020207@swiss-it.ch>
References: <1212671211.6339.58.camel@martin> <4847F310.7020207@swiss-it.ch>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 05 Jun 2008 16:45:01 +0200
Message-Id: <1212677101.6339.75.camel@martin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8BIT
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jun  5 16:46:05 2008
X-DSPAM-Confidence: 0.9980
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4847fc2d304361943658899
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> You could register a new SADB algorithm id in pfkeyv2.h and add a new
> entry to the aalg_list analogous to how GCM is doing that in the aead_list.
> 
> Adrian

We could do that, but ﻿SADB_X_AALG_SHA2_256HMAC (5) actually refers to
128 bit truncation. 96 bit truncation is a leftover of
draft-ietf-ipsec-ciph-sha-256-00 and has been replaced by 128 bit
truncation in draft-ietf-ipsec-ciph-sha-256-01. 

d﻿raft-kelly-ipsec-ciph-sha2 and the resulting RFC4868 define 128 bit
truncation for ﻿SADB_X_AALG_SHA2_256HMAC (5), so 96 bit truncation is
really obsolete. We could define a new PF_KEY algorithm for 96 bit
truncation, but it is not really usable as it is not standardized.

Martin



