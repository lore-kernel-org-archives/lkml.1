Return-Path: <linux-kernel-owner+w=401wt.eu-S1753387AbYCZDYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbYCZDYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 23:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbYCZDYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 23:24:05 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:38312 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbYCZDYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 23:24:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HU79nWtl3i7OnBjFEJ/uoCIaGN54+fyXGbXU4AKAPBzseF8tvKLAw2YreETNsdhA+201aXIPVZcybHCAZYKQBA+2UwIWBJxdxb1PGXjSMEfzkQFfj5w5+wcxFCv1GTSaREn6V6AuEqnNLMuFDO3zw6r9jGobvarWEfrRGgEEBDI=
Message-ID: <5d6222a80803252024u6bb5d4ddk556329ec6ce56@mail.gmail.com>
Date: Wed, 26 Mar 2008 00:24:02 -0300
From: "Glauber Costa" <glommer@gmail.com>
To: "Jack Steiner" <steiner@sgi.com>
Subject: Re: [RFC 8/8] x86_64: Support for new UV apic
Cc: "Ingo Molnar" <mingo@elte.hu>, tglx@linutronix.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080325163103.GA2651@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080324182122.GA28327@sgi.com> <20080325143059.GB11323@elte.hu>
	 <20080325163103.GA2651@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 1:31 PM, Jack Steiner <steiner@sgi.com> wrote:
> On Tue, Mar 25, 2008 at 03:30:59PM +0100, Ingo Molnar wrote:
>  >
>  > * Jack Steiner <steiner@sgi.com> wrote:
>  >
>  > > Index: linux/arch/x86/kernel/genapic_64.c
>  >
>  > > @@ -69,7 +73,16 @@ void send_IPI_self(int vector)
>  > >
>  > >  unsigned int get_apic_id(void)
>  > >  {
>  > > -   return (apic_read(APIC_ID) >> 24) & 0xFFu;
>  > > +   unsigned int id;
>  > > +
>  > > +   preempt_disable();
>  > > +   id = apic_read(APIC_ID);
>  > > +   if (uv_system_type >= UV_X2APIC)
>  > > +           id  |= __get_cpu_var(x2apic_extra_bits);
>  > > +   else
>  > > +           id = (id >> 24) & 0xFFu;;
>  > > +   preempt_enable();
>  > > +   return id;
>  >
>  > dont we want to put get_apic_id() into struct genapic instead? We
>  > already have ID management there.
>  >
>  > also, we want to unify 32-bit and 64-bit genapic code and just have
>  > genapic all across x86.
>
>  Long term, I think that makes sense. However, I think that should be a
>  separate series of patches since there are significant differences between
>  the 32-bit and 64-bit genapic structs.
>
However, if you add more code, they'll keep diverging. The moment you
touch them, and get your
hands warmed up, is the perfect moment for an integration series.

-- 
Glauber Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
