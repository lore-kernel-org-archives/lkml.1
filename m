Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbXIHKth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbXIHKth (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 06:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbXIHKt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 06:49:29 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:49053 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751356AbXIHKt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 06:49:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=5d0caVr75f3vKwTHiJ+gZ5xd7gclA4yJEseg9tobBhosjaDuEAFZAE/6wVxe19eq6YDeiuHUj4kJkqQjrGo5xvsp8Mrr0dP800Qodl1/uX1bCwsge8MVUHUS5ncPJ7KW4WcSubTDxlcJf9Hvccj0X9s0+WoapC35E8uE6E3EQPg=  ;
X-YMail-OSG: WX7BiUIVM1nl4ZS5MbZyTLb3h2GBJVcg9dKbkflPpyaOD64D2VpWMD2BRpZPQFmeroaJo47FqpfxU7Oxwhww5uF_TOdJFtn3ZeOY7lFj2XjvkvR1xzq2x2yhLzyEQyL5eCbisNZXU2Y0bOuK
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Intel Memory Ordering White Paper
Date: Sat, 8 Sep 2007 06:46:56 +1000
User-Agent: KMail/1.9.5
Cc: Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org
References: <200709071526.51169.jesse.barnes@intel.com> <200709081854.57549.nickpiggin@yahoo.com.au> <20070908113056.66fc97b7@the-village.bc.nu>
In-Reply-To: <20070908113056.66fc97b7@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709080646.56200.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 September 2007 20:30, Alan Cox wrote:
> On Sat, 8 Sep 2007 18:54:57 +1000
>
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > On Saturday 08 September 2007 08:26, Jesse Barnes wrote:
> > > FYI, we just released a new white paper describing memory ordering for
> > > Intel processors:
> > > http://developer.intel.com/products/processor/manuals/index.htm
> > >
> > > Should help answer some questions about some of the ordering primitives
> > > we use on i386 and x86_64.
> >
> > So, can we finally noop smp_rmb and smp_wmb on x86?
>
> Nakked-by: Alan Cox <alan@redhat.com>
>
> You can only no-op it on 64bit Intel processors. On 32bit it needs to be
> conditional on whether your processor family (or back compat for it) as
> the Pentium Pro has some serious store ordering errata (hence the way it
> needs lock decb for spin_unlock)

We already noop smp_wmb on i386 even when CONFIG_X86_PPRO_FENCE.

I'm not sure if either errata can be solved completely by adding lock ops
in barrier instructions anyway: they both seem to involve situations where
there is just a single problematic cacheline in question.
