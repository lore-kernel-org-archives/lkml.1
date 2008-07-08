Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbYGHMBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbYGHMBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYGHMB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:01:29 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:45402 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717AbYGHMB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:01:28 -0400
Date: Tue, 8 Jul 2008 16:00:53 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: austin zhang <austin_zhang@linux.intel.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, chaapala@cisco.com,
       linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com
Subject: Re: FW: [Fwd: [PATCH]Using Intel CRC32 instruction to implement hardware accelerated CRC32c algorithm.]
Message-ID: <20080708120050.GA6410@2ka.mipt.ru>
References: <000901c8e0d4$6f5cf230$7fb410ac@ccr.corp.intel.com> <1215512754.2906.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1215512754.2906.23.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Tue, Jul 08, 2008 at 06:25:54AM -0400, austin zhang (austin_zhang@linux.intel.com) wrote:
> > designed to support sync just as well as async despite the name)
> ﻿Do you mean use async_xxx interface?

No, async_xxx is very different hardware assist, although it can be
converted to cryptoapi too.

> > to rewrite the crypto/crc32c implementation such that one tfm can
> > be used by multiple users.  All that has to be done is to move
> > the state from the tfm into the request object.
>  
> > 2) Convert all crc32c users to use the crypto interface and phase
> > out lib/crc32c completely.
> > 
> > 3) Add the Intel-specific crc32c implementation through the crypto
> > API.
> Agreed. And which module in crypto is the template for following the crypto API?

This is some kind of how cbc(cipher) or ecb(cipher) templates are done:
cbc(aes), cbc(aes-i686) for example.
The same would be possible to do with crc32c but for checksumming (which
is effectively a hash).

-- 
	Evgeniy Polyakov
