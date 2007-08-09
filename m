Return-Path: <linux-kernel-owner+w=401wt.eu-S934734AbXHIHCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934734AbXHIHCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 03:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754097AbXHIHCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 03:02:18 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:60354 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbXHIHCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 03:02:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cL1r+wVSP25PoQPFJ1Ll/YCm0zwKIsT7XxGwSnBjobH3oI8RxrwS9XAGfdDK2n5El2euayFt6dTOkB+35kWxmvEfuSIYV+N3psG1bxcSkG/xzwyup8LGQu6QrBiN7/epfQHGtyswrtUl1e5ekdYKpGY+C8oa+RFCKuq7tsi/AL4=
Message-ID: <5d6222a80708090002y7fdc6f2dw1dbacd3d27a86433@mail.gmail.com>
Date: Thu, 9 Aug 2007 04:02:14 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [PATCH 25/25] [PATCH] add paravirtualization support for x86_64
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, mingo@elte.hu, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <46BAB5C8.5090906@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11865467522495-git-send-email-gcosta@redhat.com>
	 <1186546820708-git-send-email-gcosta@redhat.com>
	 <11865468243612-git-send-email-gcosta@redhat.com>
	 <11865468321629-git-send-email-gcosta@redhat.com>
	 <11865468362401-git-send-email-gcosta@redhat.com>
	 <11865468394005-git-send-email-gcosta@redhat.com>
	 <11865468431616-git-send-email-gcosta@redhat.com>
	 <1186546847263-git-send-email-gcosta@redhat.com>
	 <11865468513077-git-send-email-gcosta@redhat.com>
	 <46BAB5C8.5090906@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > +     case PARAVIRT_PATCH(make_pgd):
> > +     case PARAVIRT_PATCH(pgd_val):
> > +     case PARAVIRT_PATCH(make_pte):
> > +     case PARAVIRT_PATCH(pte_val):
> > +     case PARAVIRT_PATCH(make_pmd):
> > +     case PARAVIRT_PATCH(pmd_val):
> > +     case PARAVIRT_PATCH(make_pud):
> > +     case PARAVIRT_PATCH(pud_val):
> > +             /* These functions end up returning what
> > +                they're passed in the first argument */
> >
>
> Is this still true with 64-bit?  Either way, I don't think its worth
> having this here.  The damage to codegen around all those sites has
> already happened, and the additional cost of a noop direct call is
> pretty trivial.  I think this is a nanooptimisation which risks more
> problems than it could possibly be worth.

No it is not. But it is just the comment that is broken. (I forgot to
update it). The case here, is that they put in rax what they receive
in rdi.

> > +     case PARAVIRT_PATCH(set_pte):
> > +     case PARAVIRT_PATCH(set_pmd):
> > +     case PARAVIRT_PATCH(set_pud):
> > +     case PARAVIRT_PATCH(set_pgd):
> > +             /* These functions end up storing the second
> > +              * argument in the location pointed by the first */
> > +             ret = paravirt_patch_store_reg(insns, len);
> > +             break;
> >
>
> Ditto, really.  Do this in a later patch if it actually seems to help.

Okay, I can remove them both.

> > +/*
> > + * integers must be use with care here. They can break the PARAVIRT_PATCH(x)
> > + * macro, that divides the offset in the structure by 8, to get a number
> > + * associated with the hook. Dividing by four would be a solution, but it
> > + * would limit the future growth of the structure if needed.
> >
>
> Why not just stick them at the end of the structure?

Does it really matter?

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
