Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbZFAH7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbZFAH7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 03:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbZFAH6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 03:58:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43202 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752560AbZFAH6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 03:58:52 -0400
Date: Mon, 1 Jun 2009 08:58:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Miller <davem@davemloft.net>, riel@redhat.com,
       research@subreption.com, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu, linux-mm@kvack.org, torvalds@osdl.org,
       linux-crypto@vger.kernel.org
Subject: Re: [PATCH] Use kzfree in crypto API context initialization and
 key/iv handling
Message-ID: <20090601085814.3e010533@lxorguk.ukuu.org.uk>
In-Reply-To: <20090601044837.GA9220@gondor.apana.org.au>
References: <20090531025720.GC9033@oblivion.subreption.com>
	<20090530.230213.73434433.davem@davemloft.net>
	<4A22967C.3080304@redhat.com>
	<20090531.214623.76344831.davem@davemloft.net>
	<20090601044837.GA9220@gondor.apana.org.au>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jun 2009 14:48:37 +1000
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Sun, May 31, 2009 at 09:46:23PM -0700, David Miller wrote:
> > 
> > I don't even want to think about what this does to IPSEC rule creation
> > rates, that that matters heavily for cell phone networks where
> > hundreds of thousands of nodes come in and out of the server and each
> > such entry requires creating 4 IPSEC rules.
> 
> I completely agree.  The zeroing of metadata is gratuitous.

Zeroing long term keys makes sense but for the short lifepsan keys used on
the wire its a bit pointless irrespective of speed (I suspect done
properly the performance impact would be close to nil anyway)

