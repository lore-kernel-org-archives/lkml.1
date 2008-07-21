Return-Path: <linux-kernel-owner+w=401wt.eu-S1758680AbYGULcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680AbYGULcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 07:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbYGULcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 07:32:11 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62677 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752119AbYGULcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 07:32:10 -0400
Date: Mon, 21 Jul 2008 12:31:06 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Mikael Pettersson <mikpe@it.uu.se>
cc: Ingo Molnar <mingo@elte.hu>, Chuck Ebbert <cebbert@redhat.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: PIC, L-APIC and I/O APIC debug information
In-Reply-To: <18563.55832.673541.202465@harpo.it.uu.se>
Message-ID: <Pine.LNX.4.55.0807211222250.23386@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0807202226310.24038@cliff.in.clinika.pl>
 <18563.55832.673541.202465@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008, Mikael Pettersson wrote:

>  > +#define __apicdebuginit(type) static type __init
> ...
>  > -void __init print_IO_APIC(void)
>  > +
>  > +__apicdebuginit(void) print_IO_APIC(void)
>  >  {
> 
> I _really_ dislike how this abuses the C macro preprocessor
> to create pointless new syntax.
> 
> Since you're editing these function definitions anyway why
> not just spell out "static void __init" in readable proper C?

 This is so that while debugging you can make all these functions global
with a single change in one place, rather than going through the whole
file and finding all the relevant function headers.  Presumably the
original reason for the existence of the macro.  Unfortunately an
object-like macro cannot be used here, as the "static" keyword has to come
first in a function declaration and the section attribute has to come
after the type designation.

 What's wrong with the syntax in your opinion?

  Maciej
