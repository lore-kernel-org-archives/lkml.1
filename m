Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbZCCCJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbZCCCJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 21:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbZCCCJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 21:09:28 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:46644 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbZCCCJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 21:09:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kJjxQp7GSselnSlnyYMnIrgpizWCyHRLnPzK5OZUkre4Z733zEy/2z0Ppc3sEHblWE
         l3d3+fvV77szifwUcz6xcCObV9DKoEihXaC5hX8adxiiNUlpMYKO8i8BLe+ZiGFoAXv3
         PRWinyNGJKPtjrY9WhH2IXYAUph1i8fABglDo=
Subject: Re: [PATCH 1/2] byteorder: add load/store_{endian} API
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Boaz Harrosh <bharrosh@panasas.com>
In-Reply-To: <alpine.LFD.2.00.0903021749030.3111@localhost.localdomain>
References: <1236038817.5756.11.camel@brick>
	 <alpine.LFD.2.00.0903021613590.3111@localhost.localdomain>
	 <1236039944.5756.19.camel@brick>
	 <alpine.LFD.2.00.0903021632320.3111@localhost.localdomain>
	 <1236040845.5756.33.camel@brick>
	 <alpine.LFD.2.00.0903021749030.3111@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 18:09:19 -0800
Message-Id: <1236046159.5756.43.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 17:51 -0800, Linus Torvalds wrote:
> 
> On Mon, 2 Mar 2009, Harvey Harrison wrote:
> > 
> > OK, static inline it is then. Would you be opposed to an API like:
> > 
> > get_le16
> > put_le16
> > 
> > to match with 
> >
> > get_unaligned_le16
> > put_unaligned_le16
> > 
> > And make the existing unaligned helpers typesafe?
> 
> That sounds much better to me. That said, I'm also wondering what the 
> upside is of this all?
> 

1) Recognize that some drivers/subsystems want this, or already
implement it privately

2) [micro-optimization] Allow arches that do provide load/store swapped
instructions to be used more often.

3) make it more likely that people will actually use the unaligned
helpers rather than open-coding the byteswapping, allowing arches that
have no alignment constraints to just do regular loads if possible.

Disadvantages:

1) existing users of the get_unaligned bits may/will produce sparse
warnings on the flag day

2) the existing argument ordering of put_unaligned is opposite what
is usually expected in such a helper

3) [nitpicky] get/put almost always means reference taking/releasing,
load/store is the usual verb used for such an API.

Harvey

