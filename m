Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbXKXRz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbXKXRz4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 12:55:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbXKXRzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 12:55:47 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:62571 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752911AbXKXRzq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 12:55:46 -0500
Date: Sat, 24 Nov 2007 18:53:32 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Luciano Rocha <strange@nsk.no-ip.org>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, Daniel Drake <dsd@gentoo.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net, kune@deine-taler.de,
       johannes@sipsolutions.net
Subject: Re: [RFC] Documentation about unaligned memory access
Message-ID: <20071124185332.5ed9de3f@siona>
In-Reply-To: <20071124172236.GA16944@bit.office.eurotux.com>
References: <20071123001554.12F8B9D4A1F@zog.reactivated.net>
	<20071124143441.41657307@poseidon.drzeus.cx>
	<20071124155052.GA15440@bit.office.eurotux.com>
	<20071124171931.699aa1ff@poseidon.drzeus.cx>
	<20071124172236.GA16944@bit.office.eurotux.com>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Nov 2007 17:22:36 +0000
Luciano Rocha <strange@nsk.no-ip.org> wrote:

> Nothing does, even memcpy doesn't check alignment of the source, or
> alignment at all in some assembly implementations (only word-copy,
> without checking if at word-boundary).

An out-of-line implementation can only do that if the architecture
allows unaligned loads and stores. Since it has no clue about the types
involved, it must assume that both pointers as well as the length may be
misaligned.

gcc, on the other hand, knows exactly what types are involved, so when
it expands its own builtin-memcpy inline it can optimize it based on
the required alignment of those types. So when you cast between types
with different alignment requirements, you must make sure the result is
properly aligned, or you need to use get_unaligned()/put_unaligned()
to override gcc's assumptions.

Btw, some versions of avr32-gcc (I think it was 4.0.x) assumed packed
structs were properly aligned too, with disastrous results. gcc-4.1
handles packed structs correctly as far as I can tell.

Håvard
