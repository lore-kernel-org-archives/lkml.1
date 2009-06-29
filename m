Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbZF2N2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbZF2N2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 09:28:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbZF2N1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 09:27:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:48385 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbZF2N1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 09:27:54 -0400
Subject: Re: surpring results of test_and_set_bit() and
 test_and_clear_bit() functions in Linux-2.6.25 kernel at x86_64 architecture
From: Petr Tesarik <ptesarik@suse.cz>
To: qingbo yuan <yuanbor.maillist@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <2ab84cd80906170342ta334955yc69a2648fa979979@mail.gmail.com>
References: <2ab84cd80906170340w3ad8b938t64b6d0926b18daa4@mail.gmail.com>
	 <2ab84cd80906170342ta334955yc69a2648fa979979@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: SUSE LINUX
Date: Mon, 29 Jun 2009 15:27:56 +0200
Message-Id: <1246282076.7698.10.camel@nathan.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

qingbo yuan píše v St 17. 06. 2009 v 18:42 +0800:
> hi,all
> I recently encountered a strange phenomenon about test_and_set_bit()
> and test_and_clear_bit().
> [...]
> So, if the old bit is '0', these functions return 0;
>       if the old bit is '1', these functions return -1;
> Both of these functions were right if the comments modified as
> "test_and_set_bit - Set a bit and return its opposite old value".
> 
> Can anybody point out what problems exist in my analysis?

None. Just, the intended return type of those functions is actually
bool, I think, so it doesn't matter if they return 1 or -1. Any non-zero
value will do.

OTOH choosing the word "opposite" is probably unfortunate, because most
people would have difficulties understanding what the function really
returns.

And while we're at nitpicking, what makes you think that a single bit
integer must be an unsigned int? If I look at one bit as a signed int,
then it can hold the values 0 and -1. The test_and_*_bit() merely
sign-extend the bit...

Petr Tesarik

