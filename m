Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245AbYCRA5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbYCRA5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 20:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbYCRA5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 20:57:09 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:53294 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752250AbYCRA5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 20:57:08 -0400
Date: Tue, 18 Mar 2008 08:56:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Christian Kujau <lists@nerdbynature.de>, Chr <chunkeey@web.de>,
       Milan Broz <mbroz@redhat.com>, David Chinner <dgc@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
       dm-devel@redhat.com, dm-crypt@saout.de,
       Ritesh Raj Sarraf <rrs@researchut.com>
Subject: Re: [dm-crypt] INFO: task mount:11202 blocked for more than 120 seconds
Message-ID: <20080318005653.GA14575@gondor.apana.org.au>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <200803150108.04008.chunkeey@web.de> <200803151432.11125.chunkeey@web.de> <200803152234.53199.chunkeey@web.de> <alpine.DEB.1.00.0803161406040.6213@sheep.housecafe.de> <20080317173609.GD29322@agk.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080317173609.GD29322@agk.fab.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 05:36:09PM +0000, Alasdair G Kergon wrote:
> Latest version for everyone to try:
> 
> From: Milan Broz <mbroz@redhat.com>
> 
> Fix regression in dm-crypt introduced in commit
> 3a7f6c990ad04e6f576a159876c602d14d6f7fef
> (dm crypt: use async crypto).
> 
> If write requests need to be split into pieces, the code must not
> process them in parallel because the crypto context cannot be shared.
> So there can be parallel crypto operations on one part of the write,
> but only one write bio can be processed at a time.

Could you explain this part please? Crypto tfm objects are meant
to be reentrant, synchronous or not.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
