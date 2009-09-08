Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbZIHFJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbZIHFJm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 01:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbZIHFJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 01:09:42 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:39823 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbZIHFJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 01:09:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=O8WFvn+kjjQypF9lwyX9MLcxAuK/A/wvFMtcfQyKI11GOJ7YYA+u5r780EfBs1L9ac
         AX1Gk5RG1z8sVW8GiRe8ZN95XJEq9bMeFUjJmTG2TBZF+6smYuq/xiTHW7LGrvewT8Ou
         K/BUKOtCk0tNoDVnpNabI/Hf7wIjWarTqmAuw=
MIME-Version: 1.0
In-Reply-To: <20090907204913.2aef5c49@infradead.org>
References: <3877989d0909071926q77aac67cj532137513710025d@mail.gmail.com>
	 <20090907204913.2aef5c49@infradead.org>
Date: Tue, 8 Sep 2009 13:09:44 +0800
Message-ID: <3877989d0909072209g454d92feuc0d3cdbd95a13a9c@mail.gmail.com>
Subject: Re: [RFC PATCH] C2 could be mapped to C3 so need a flush cache
From: Luming Yu <luming.yu@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 8, 2009 at 11:49 AM, Arjan van de Ven<arjan@infradead.org> wrote:
> On Tue, 8 Sep 2009 10:26:06 +0800
> Luming Yu <luming.yu@gmail.com> wrote:
>
>> Hi there,
>>
>> I came across acpi_idle_enter_simple, noticed it looks like a bug if
>> we don't flush cache for C2.
>> Because some platforms just map C2 to C3.
>
> I think you are confusing ACPI C3 with HW C3.
>
> Only for ACPI C3 class do you need to flush the cache for this case.
> For HW C3, if you would need to flush the cache, the BIOS would assign
> it ACPI C3 class.
>

There is no confusion,I just extend the existing kernel logic as below
to cover cache flush..

"
"/*
 * Some BIOS implementations switch to C3 in the published C2 state.
 * This seems to be a common problem on AMD boxen, but other vendors
 * are affected too. We pick the most conservative approach: we assume
 * that the local APIC stops in both C2 and C3.
 */
static void lapic_timer_check_state

"
