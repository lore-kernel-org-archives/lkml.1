Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbYCIUby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbYCIUby (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 16:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbYCIUbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 16:31:46 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:57560 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379AbYCIUbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 16:31:45 -0400
Message-Id: <1205094704.6430.1241420859@webmail.messagingengine.com>
X-Sasl-Enc: abbO8qiJXEQusUIuqiH2vlLT+6ZztHCVVfmDylqp2KWC 1205094704
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Ingo Molnar" <mingo@elte.hu>,
       "Alexander van Heukelum" <heukelum@mailshack.com>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "LKML" <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20080309200103.GA895@mailshack.com> <20080309201152.GB28454@elte.hu>
Subject: Re: [PATCH] x86: Change x86 to use generic find_next_bit
In-Reply-To: <20080309201152.GB28454@elte.hu>
Date: Sun, 09 Mar 2008 21:31:44 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 9 Mar 2008 21:11:52 +0100, "Ingo Molnar" <mingo@elte.hu> said:
> * Alexander van Heukelum <heukelum@mailshack.com> wrote:
> > --- a/lib/find_next_bit.c
> > +++ b/lib/find_next_bit.c
> > @@ -15,6 +15,8 @@
> >  #include <asm/byteorder.h>
> >  
> >  #define BITOP_WORD(nr)		((nr) / BITS_PER_LONG)
> > +#undef find_next_bit
> > +#undef find_next_zero_bit
> 
> this bit looks weird - did you need it for testing?

Worse, it's needed to get x86_64 to compile.

They are defined in include/asm-x86/bitops_64.h (which gets
included). They are used to optimize the case where the
bitmap size is known at compile time and not larger than
BITS_PER_LONG. Undeffing them here is the easiest way to get
things to compile, here.

Greetings,
    Alexander

-- 
http://www.fastmail.fm - The way an email service should be

