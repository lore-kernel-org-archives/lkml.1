Return-Path: <linux-kernel-owner+w=401wt.eu-S1763578AbZFLKL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763578AbZFLKL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754632AbZFLKLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:11:51 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:51603 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690AbZFLKLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:11:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=AfLnYQO70vGEOiW6yeLln25ByiCGAAgbxICCyCNsXpCzGWyvMfJlebjjHCOIYY76s4
         fVDPSO28iIYZg5ovt33NW9gExyEeUlyFlwNt6TGiTRQhjbGi9pNbEm3/WdwN8LcywqcJ
         w6aComo0DU61dXi2dvyIdzYMS4bnIBfk6Py9Y=
MIME-Version: 1.0
In-Reply-To: <20090612100756.GA25185@elte.hu>
References: <Pine.LNX.4.64.0906121113210.29129@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121201490.30049@melkki.cs.Helsinki.FI>
	 <20090612091002.GA32052@elte.hu>
	 <84144f020906120249y20c32d47y5615a32b3c9950df@mail.gmail.com>
	 <20090612100756.GA25185@elte.hu>
Date: Fri, 12 Jun 2009 13:11:52 +0300
X-Google-Sender-Auth: be1770cb4f7a34af
Message-ID: <84144f020906120311x7c7dd628s82e3ca9a840f9890@mail.gmail.com>
Subject: Re: [PATCH v2] slab,slub: ignore __GFP_WAIT if we're booting or 
	suspending
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       benh@kernel.crashing.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Fri, Jun 12, 2009 at 1:07 PM, Ingo Molnar<mingo@elte.hu> wrote:
> IMHO such invisible side-channels modifying the semantics of GFP
> flags is a bit dubious.
>
> We could do GFP_INIT or GFP_BOOT. These can imply other useful
> modifiers as well: panic-on-failure for example. (this would clean
> up a fair amount of init code that currently checks for an panics on
> allocation failure.)

OK, but that means we need to fix up every single caller. I'm fine
with that but Ben is not. As I am unable to test powerpc here, I am
inclined to just merge Ben's patch as "obviously correct".

That does not mean we can't introduce GFP_BOOT later on if we want to. Hmm?

                        Pekka
