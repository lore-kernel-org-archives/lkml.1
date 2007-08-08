Return-Path: <linux-kernel-owner+w=401wt.eu-S935288AbXHHOUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935288AbXHHOUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934432AbXHHOTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:19:54 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:57931 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935103AbXHHOTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:19:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BKl2Hf4C0cys30rnHwJay60DZ45nW7MEL3CZojkMH5LvGDFIWkhCNDdo1TxczoI8TFyTpoF/z6QqO00exgwhgRRtIfxJX7hzNvH5UYcNncLtbcp2/L662q5L5+RvFkTF9/k7iVHBy9ry73gR/+sjIIncq/1tfYq10xvgfwctz54=
Message-ID: <5d6222a80708080719k2e2723mdf82572624856246@mail.gmail.com>
Date: Wed, 8 Aug 2007 11:19:50 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH 13/25] [PATCH] turn msr.h functions into native versions
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, mingo@elte.hu, chrisw@sous-sol.org,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <200708081125.38481.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11865467522495-git-send-email-gcosta@redhat.com>
	 <11865468003673-git-send-email-gcosta@redhat.com>
	 <11865468043920-git-send-email-gcosta@redhat.com>
	 <200708081125.38481.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/07, Andi Kleen <ak@suse.de> wrote:
> On Wednesday 08 August 2007 06:19, Glauber de Oliveira Costa wrote:
>
> > +static __always_inline long long vget_cycles_sync(void)
>
> Why is there a copy of this function now? That seems wrong

Yeah, the other one is in i386 headers, so We probably wan't to leave
it there. One option is to move get_cycles_sync to x86_64 headers, and
then #ifdef just the offending part.

> > +             native_read_tscp(&p);
>
> The instruction is called rdtscp not read_tscp. Please follow that

Although the operation consists in reading tscp. I choose this to be
consistent with i386, but I have no special feelings about it. I'm
okay with changing it if you prefer.

> > +#define rdtsc(low, high)                     \
>
> This macro can be probably eliminated, no callers in kernel
>
>
Fine.

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
