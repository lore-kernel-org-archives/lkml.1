Return-Path: <linux-kernel-owner+w=401wt.eu-S1765948AbYDPRFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765948AbYDPRFE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 13:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760456AbYDPREx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 13:04:53 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:40325 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752260AbYDPREw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 13:04:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=5prrhIND1XXC5G9jzNjEHqX3OeoFUyzmzH/V3rGTeoaQVO7GP8lYTs4M4hLbql8FiOnPwN02Tc5tt8D5ZACNHw12yqlJ2l2H179nhvE4d+3iXp+XvJg9GzR+wQIqdoKwMyCAf9RGvQGxFs7LLZMCpt9aD0aY6heuGTRCNB2iebU=  ;
X-YMail-OSG: wknE3doVM1kI2Yxn.BngNBUfYLUWuwrDu_y.5OCkxVrZVwCDYfkHmVZZlvPzv7a6v5f.QN4wug--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch 2.6.25-rc8] omap_rng minor updates
Date: Wed, 16 Apr 2008 10:04:49 -0700
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, linux-omap@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>
References: <200804102132.03907.david-b@pacbell.net> <20080416112517.GA29220@gondor.apana.org.au>
In-Reply-To: <20080416112517.GA29220@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200804161004.50075.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 April 2008, Herbert Xu wrote:
> > Minor cleanups to the OMAP RNG:
> 
> Thanks.  I've picked this up in cryptodev-2.6.

Is that where the RNG stuff is now getting maintained?


If so, I wonder what should be done with some other
RNG changes sitting in one of my trees.  Briefly,
their initializations come late ... and after kernel
code has already started to use the kernel pool.  So
attacks based on known RNG patterns are possible at
that time.

So the patch I had -- needs reworking -- moves the
RNG driver initializations earlier, and uses the
first one to seed the kernel pool.  Cryptographically
that would be no worse than the current situation (even
if you don't wholly trust the RNG), and in most cases
would be a distinct improvement.

- Dave

