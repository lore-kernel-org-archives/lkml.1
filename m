Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbYFZGC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbYFZGC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 02:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYFZGCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 02:02:18 -0400
Received: from gir.skynet.ie ([193.1.99.77]:32888 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbYFZGCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 02:02:18 -0400
Date: Thu, 26 Jun 2008 07:02:15 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Keith Packard <keithp@keithp.com>, Arjan van de Ven <arjan@infradead.org>,
       Dave Airlie <airlied@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kmap_atomic_pfn for PCI BAR access?
In-Reply-To: <48633057.1040106@goop.org>
Message-ID: <alpine.DEB.0.82.0806260701260.25035@skynet.skynet.ie>
References: <1214242487.11887.35.camel@koto.keithp.com>  <4862EE4C.4060009@goop.org>
  <21d7e9970806251823q3405e192q13d4944bd0cc3291@mail.gmail.com> 
 <20080625213603.0e82805b@infradead.org> <1214458589.1044.45.camel@koto.keithp.com>
 <48633057.1040106@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >   
> 
> Anything that does any kind of pagetable manipulation needs to do tlb flushes.
> kunmap_atomic handles the flushing.

It doesn't however need to do an IPI dance which is the worst part of 
doing a tlb flush on SMP machines.

flushing local CPU tlbs is bad, but doing IPIs and waiting for everyone 
else is brutal.

Dave.
