Return-Path: <linux-kernel-owner+w=401wt.eu-S1754317AbXKVDhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317AbXKVDhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 22:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbXKVDhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 22:37:08 -0500
Received: from cantor.suse.de ([195.135.220.2]:34864 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbXKVDhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 22:37:06 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
Date: Thu, 22 Nov 2007 04:37:01 +0100
User-Agent: KMail/1.9.6
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sam@ravnborg.org,
       rusty@rustcorp.com.au
References: <20071122343.446909000@suse.de> <20071121190304.6bf682b5@laptopd505.fenrus.org>
In-Reply-To: <20071121190304.6bf682b5@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711220437.01968.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I like this concept in general; I have one minor comment; right now
> your namespace argument is like
> 
> EXPORT_SYMBOL_NS(foo, some_symbol);
> 
> from a language-like pov I kinda wonder if it's nicer to do
> 
> EXPORT_SYMBOL_NS("foo", some_symbol);
> 
> because foo isn't something in C scope, but more a string-like
> identifier...

That wouldn't work for MODULE_ALLOW() because it appends the namespace
to other identifiers. I don't know of a way in the C processor to get
back from a string to a ## concatenable identifier.

For EXPORT_SYMBOL_NS it would be in theory possible, but making 
it asymmetric to MODULE_ALLOW would be ugly imho.

-Andi
