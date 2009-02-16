Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbZBPBjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbZBPBjZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 20:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbZBPBjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 20:39:15 -0500
Received: from waste.org ([66.93.16.53]:52832 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440AbZBPBjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 20:39:14 -0500
Subject: Re: [PATCH] Export symbol ksize()
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-crypto@vger.kernel.org, Geert.Uytterhoeven@sonycom.com
In-Reply-To: <20090215170052.44ee8fd5.akpm@linux-foundation.org>
References: <1234272104-10211-1-git-send-email-kirill@shutemov.name>
	 <84144f020902100535i4d626a9fj8cbb305120cf332a@mail.gmail.com>
	 <20090210134651.GA5115@epbyminw8406h.minsk.epam.com>
	 <Pine.LNX.4.64.0902101605070.20991@melkki.cs.Helsinki.FI>
	 <20090212104349.GA13859@gondor.apana.org.au>
	 <1234435521.28812.165.camel@penberg-laptop>
	 <20090212105034.GC13859@gondor.apana.org.au>
	 <1234454104.28812.175.camel@penberg-laptop>
	 <20090215133638.5ef517ac.akpm@linux-foundation.org>
	 <1234734194.5669.176.camel@calx>
	 <20090215135555.688ae1a3.akpm@linux-foundation.org>
	 <1234741781.5669.204.camel@calx>
	 <20090215170052.44ee8fd5.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sun, 15 Feb 2009 19:38:36 -0600
Message-Id: <1234748316.5669.222.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-02-15 at 17:00 -0800, Andrew Morton wrote:
> On Sun, 15 Feb 2009 17:49:41 -0600 Matt Mackall <mpm@selenic.com> wrote:

> The whole concept is quite hacky and nasty, isn't it?.

It is, which is part of why we were trying to kill it. The primary users
were thing growing buffers ala realloc. So we were pushing to change the
callers to just do a realloc. But IPSEC doesn't fit well into that mold.

The fundamental problem here for networking is that 1500 is not very
close to a power of two and just about everything in the VM wants it to
be. If we could get SKBs fitting more nicely in memory, I think it would
cease to be a concern.

-- 
http://selenic.com : development and support for Mercurial and Linux


