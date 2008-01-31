Return-Path: <linux-kernel-owner+w=401wt.eu-S933104AbYAaW6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104AbYAaW6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:58:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbYAaW6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:58:04 -0500
Received: from wr-out-0506.google.com ([64.233.184.232]:18487 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbYAaW6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:58:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kJxF6QtqzXiS3cCl63LLoPo1aOu68rLS8TKBAjsU1rPpZ5TDk1R94lXGj/a91ADZ/7y3KYZ+M+IZcmi7ZCdFfWRowc2CPz0eB+kC/aVuHMuwSIQwRr8VvXAO1DhBkoxpaumABpMJ0ZXyQ46ntmvbYsIo6Hks9PLZa0apLMZ1zLA=
Message-ID: <4d8e3fd30801311457x3edc67eap16c03f511dca506b@mail.gmail.com>
Date: Fri, 1 Feb 2008 02:27:57 +0330
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Joe Perches" <joe@perches.com>
Subject: Re: [PATCH 6/7] X86: include missing KERN_ facility level
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1201563036.23527.22.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080129000803.69b54c7e@paolo-desktop>
	 <1201563036.23527.22.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/29/08, Joe Perches <joe@perches.com> wrote:
> On Tue, 2008-01-29 at 00:08 +0100, Paolo Ciarrocchi wrote:
> > \diff --git a/arch/x86/math-emu/errors.c b/arch/x86/math-emu/errors.c
> > index 6102fe0..569a62e 100644
> > --- a/arch/x86/math-emu/errors.c
> > +++ b/arch/x86/math-emu/errors.c
> > @@ -57,65 +57,65 @@ void FPU_printall(void)
> >
> >    RE_ENTRANT_CHECK_OFF;
> >    /* No need to check access_ok(), we have previously fetched these
> bytes. */
> > -  printk("At %p:", (void *) address);
> > +  printk(KERN_ERR "At %p:", (void *) address);
> >    if (FPU_CS == __USER_CS) {
> >  #define MAX_PRINTED_BYTES 20
> >        for (i = 0; i < MAX_PRINTED_BYTES; i++) {
> >  	  FPU_get_user(byte1, (u_char __user *) address);
> >  	  if ((byte1 & 0xf8) == 0xd8) {
> > -	      printk(" %02x", byte1);
> > +	      printk(KERN_ERR " %02x", byte1);
> >  	      break;
> >  	    }
> > -	  printk(" [%02x]", byte1);
> > +	  printk(KERN_ERR " [%02x]", byte1);
> >  	  address++;
> >  	}
>
> KERN_ prefixes are used only at the start of a line.
> You should probably use print_hex_dump.


Thank you. I'll redo the patch.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
