Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbZIPJtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbZIPJtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 05:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbZIPJtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 05:49:15 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:7375 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbZIPJtO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 05:49:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=krisErnzYBUeb/0pGD6sxiMukxvU23LWzQyNavnFAc+Eq2k3q/D1MjZWHJOrHynLeD
         5lYIEAt7uY3ki1rnw3ihdngOet9JSolvzJC0UWhBwdHHf4wDFZZaS0fAr1oXa6dcRzMz
         cg9YBmuPX2n6/ItVz2ypFSQJVv6ug7gvunbPU=
MIME-Version: 1.0
In-Reply-To: <20090915145923.GC3824@aftab>
References: <20090914171905.GD13615@aftab> <20090915110940.GA8134@elte.hu>
	 <20090915163837.35701344@hyperion.delvare>
	 <20090915145923.GC3824@aftab>
Date: Wed, 16 Sep 2009 17:41:57 +0800
Message-ID: <2375c9f90909160241o8a208d9jb13b1edb0576ade7@mail.gmail.com>
Subject: Re: [origin tree build failure] Re: [GIT PULL] AMD64 EDAC updates, p1
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Jean Delvare <khali@linux-fr.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, x86 <x86@kernel.org>,
       Doug Thompson <norsk5@yahoo.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 10:59 PM, Borislav Petkov
<borislav.petkov@amd.com> wrote:
> On Tue, Sep 15, 2009 at 04:38:37PM +0200, Jean Delvare wrote:
>> On Tue, 15 Sep 2009 13:09:40 +0200, Ingo Molnar wrote:
>> > -tip testing found this build failure with the attached config:
>> >
>> > drivers/edac/edac_mce_amd.c: In function ‘decode_mce’:
>> > drivers/edac/edac_mce_amd.c:408: error: ‘per_cpu__cpu_llc_id’ undeclared (first use in this function)
>> > drivers/edac/edac_mce_amd.c:408: error: (Each undeclared identifier is reported only once
>> > drivers/edac/edac_mce_amd.c:408: error: for each function it appears in.)
>> >
>> > I did the patchlet below but this needs a cleaner fix eventually. A
>> > proper node abstraction needs to be factored out and provided as a
>> > facility regardless of config settings.
>> >
>> >     Ingo
>> >
>> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
>> > ---
>> >  drivers/edac/edac_mce_amd.c |    5 ++++-
>> >  1 file changed, 4 insertions(+), 1 deletion(-)
>> >
>> > Index: linux2/drivers/edac/edac_mce_amd.c
>> > ===================================================================
>> > --- linux2.orig/drivers/edac/edac_mce_amd.c
>> > +++ linux2/drivers/edac/edac_mce_amd.c
>> > @@ -405,8 +405,11 @@ void decode_mce(struct mce *m)
>> >             regs.nbsh  = (u32)(m->status >> 32);
>> >             regs.nbeal = (u32) m->addr;
>> >             regs.nbeah = (u32)(m->addr >> 32);
>> > +#ifdef CONFIG_X86_HT
>> >             node       = per_cpu(cpu_llc_id, m->extcpu);
>> > -
>> > +#else
>> > +           node       = 0;
>> > +#endif
>> >             amd_decode_nb_mce(node, &regs, 1);
>> >             break;
>> >
>>
>> FWIW, this patch doesn't fix the problem for me. Amerigo Wang's does:
>> http://lkml.org/lkml/2009/9/15/64
>
> We'll have an even better fix soon:
> http://marc.info/?l=linux-kernel&m=125302459621925

Yeah, agree.
