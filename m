Return-Path: <linux-kernel-owner+w=401wt.eu-S1762626AbYBTRZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762626AbYBTRZ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbYBTRZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:25:11 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:52582 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753609AbYBTRZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:25:09 -0500
Date: Thu, 21 Feb 2008 01:24:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Milan Broz <mbroz@redhat.com>
Cc: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>,
       Alasdair G Kergon <agk@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       dm-crypt@saout.de
Subject: Re: 2.6.25-rc[1,2]: failed to setup dm-crypt key mapping
Message-ID: <20080220172449.GD27726@gondor.apana.org.au>
References: <8f53421d0802192343v2267cb66ub579d4503e3b7eb1@mail.gmail.com> <47BC0DA9.1030607@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BC0DA9.1030607@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 12:23:21PM +0100, Milan Broz wrote:
>
> It seems that some module dependency was lost, 
> dm-crypt with async crypto depends now on crypto_blkcipher module
> for this configuration.
> 
> Herbert, any following change required for dm-crypt or it is only
> crypto subsystem issue?
> (With old kernel/dm-crypt it loads "blkcipher" not "crypto_blkcipher",
> maybe some initramdisk change required too...)

Right blkcipher was renamed to crypto_blkcipher due to the merge
of blkcipher/ablkcipher.  If this is causing a problem with the
initramfs then we need to fix the initramfs tools to look at the
actual dependencies rather than hard-coding it.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
