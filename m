Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbYFKDng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbYFKDng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 23:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755461AbYFKDn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 23:43:26 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:10159 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbYFKDnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 23:43:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=NAG9f7CGgCslEhk2A5AZfD5Y2iYDDNWN6wISNVfu/DYL9wuBafLMkyBaQrYTlbOTIB
         frhlBU1IEKjrO4o+cmKJkDyDvC/Rgfd6JuZ+Lew3f5H8LXLNy2gr4O8S6febgOnH/eE3
         bF26o2ydLvve7TaUf0DzGMtXmMoJp76oc0AE8=
Message-ID: <386072610806102043v3980287i1761cf43bcf0f58d@mail.gmail.com>
Date: Wed, 11 Jun 2008 11:43:22 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Adrian Bunk" <bunk@kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: blackfin drivers/net/smc91x.c build error
Cc: "Mike Frysinger" <vapier.adi@gmail.com>, "Jeff Garzik" <jeff@garzik.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <386072610806102037u39ec18e6ye26ef184d6a9516e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080606162212.GC2201@cs181133002.pp.htv.fi>
	 <8bd0f97a0806061252n1cf5ee33i40ddf9f55588e242@mail.gmail.com>
	 <20080610135349.GA30792@cs181133002.pp.htv.fi>
	 <8bd0f97a0806101013w42b9028j5dfa38d654f3d05f@mail.gmail.com>
	 <20080610173450.GC11685@cs181133002.pp.htv.fi>
	 <386072610806102037u39ec18e6ye26ef184d6a9516e@mail.gmail.com>
X-Google-Sender-Auth: c2de8c4bcd1a1264
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 11:37 AM, Bryan Wu <cooloney@kernel.org> wrote:
> On Wed, Jun 11, 2008 at 1:34 AM, Adrian Bunk <bunk@kernel.org> wrote:
>> On Tue, Jun 10, 2008 at 01:13:52PM -0400, Mike Frysinger wrote:
>>> On Tue, Jun 10, 2008 at 9:53 AM, Adrian Bunk wrote:
>>> > On Fri, Jun 06, 2008 at 03:52:09PM -0400, Mike Frysinger wrote:
>>> >> On Fri, Jun 6, 2008 at 12:22 PM, Adrian Bunk wrote:
>>> >> > drivers/net/smc91x.c fails as follows on blackfin:
>>> >> > ...
>>> >> >  CC      drivers/net/smc91x.o
>>> >> > ...
>>> >> > /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/net/smc91x.c:1863:36: error: macro "SMC_GET_MAC_ADDR" passed 2 arguments, but takes just 1
>>> >> > ...
>>> >>
>>> >> it's a known issue (been known for quite a long time actually).  Bryan
>>> >> has brought this up in the past already.
>>> >
>>> > Is my suggestion of reverting commit 099c736a470c8080a166e7a089f1e48e15f9947c
>>> > correct or how else should it be resolved?
>>>
>>> Bryan is taking care of it ... it may just stay broken in favor of
>>> waiting for the merge from the net tree.
>>>
>>> > This issue is the only remaining problem preventing that all blackfin
>>> > defconfigs will compile in 2.6.26...
>>>
>>> not really true.
>>>...
>>
>> What other build errors do you get in Linus' tree?
>>
>
> Sorry for jumping in later. I reported this issue 2 months ago.
> http://lkml.org/lkml/2008/4/7/38
>
> And Adrian is right, we need to revert this patch.
>
> Linus, could you please revert it?
> 099c736a470c8080a166e7a089f1e48e15f9947c
> Or I send a patch out to revert it?
>
> Thanks
> -Bryan
>

Oh, sorry for the confusing. we need to recommit the patch to fix this
build breakage.
9e6db60825ef7e7999abc610ce256ba768e58162
"smc91x: fix build breakage from the SMC_GET_MAC_ADDR API upgrade"

Jeff, do you have my this patch in your tree or just we revert the
099c736a470c8080a166e7a089f1e48e15f9947c?

Thanks
-Bryan
