Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbYEEG3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbYEEG3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 02:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbYEEG3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 02:29:11 -0400
Received: from ozlabs.org ([203.10.76.45]:41447 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbYEEG3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 02:29:10 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] Replace down_trylock() with down_try(), reverse return values.
Date: Mon, 5 May 2008 16:26:25 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
References: <200805051156.36437.rusty@rustcorp.com.au> <200805051609.13731.rusty@rustcorp.com.au> <20080505061217.GA13398@infradead.org>
In-Reply-To: <20080505061217.GA13398@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805051626.26136.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 May 2008 16:12:17 Christoph Hellwig wrote:
> On Mon, May 05, 2008 at 04:09:12PM +1000, Rusty Russell wrote:
> > > Given that people are actively trying to kill struct semaphore I don't
> > > think doing a big search and rename is a good idea right now.
> >
> > If it goes away before the 2.6.27 merge window, great.  But I don't see
> > that happening, so let's clean up this horror.  I cc'd all the people
> > effected in the hope that it will prod some of them towards mutexes
> > anyway.
>
> .27 might not be doable but .28 seems probable if willy and co are
> continuing to churn like they do currently.

I didn't think he was killing them all, just the ones which are actually mutex 
wannabes?

> > Ideas?  down() is pretty bad, down_try() matches it.
>
> The trylock is a convention for real locking function, so having one
> stand out would be nasty.  Then again a semaphore is not just a simple
> lock but a higher level locking primitive, so a down_nowait might make
> sense because we don't encode the lock anywhere else either

Yep, down_nowait() it is.  I'll roll a new one if willy isn't going to get rid 
of them all.

Thanks,
Rusty.
