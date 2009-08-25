Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbZHYIs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbZHYIs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 04:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbZHYIsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 04:48:23 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:47457 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbZHYIsV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 04:48:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=d8RPsoIbaOdEshW7FxA3M737KiuszbWPey7JqzowFU+VCgD14C1IkdQ2ELziXQMbCp
         TLIlSSuwUQXG0Au9XRxj74LT1UVcJRf6f7pW81qTWsAp3MyHoSQ7zxW2YqP9ufbGdpQ0
         Uk2y01XT/PoGHjV/iFF7oU4e/D0hfs8vjEVug=
MIME-Version: 1.0
In-Reply-To: <20090825084052.GE17692@elte.hu>
References: <20090825071959.GA25877@elte.hu>
	 <19f34abd0908250104y6e877545y485a2104c2b97cfd@mail.gmail.com>
	 <1251187716.7261.2.camel@penberg-laptop>
	 <1251188859.15678.6.camel@pc1117.cambridge.arm.com>
	 <1251189105.7261.4.camel@penberg-laptop>
	 <20090825084052.GE17692@elte.hu>
Date: Tue, 25 Aug 2009 11:48:21 +0300
X-Google-Sender-Auth: 12fc9161c5e1a4d5
Message-ID: <84144f020908250148x9d6a83ewccf11ef9fc32868a@mail.gmail.com>
Subject: Re: WARNING: kmemcheck: Caught 32-bit read from uninitialized memory 
	(f6f6e1a4), by kmemleak's scan_block()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Tue, Aug 25, 2009 at 11:40 AM, Ingo Molnar<mingo@elte.hu> wrote:
> There's already a couple of exclusion rules in kmemcheck:
>
> menuconfig KMEMCHECK
>        bool "kmemcheck: trap use of uninitialized memory"
>        depends on DEBUG_KERNEL
>        depends on !X86_USE_3DNOW
>        depends on SLUB || SLAB
>        depends on !CC_OPTIMIZE_FOR_SIZE
>        depends on !FUNCTION_TRACER
>
> such type of Kconfig driven exclusion is usually a somewhat lame way
> to express limitations in the software.
>
> CC_OPTIMIZE_FOR_SIZE is an externality that cannot be eliminated,
> but the others could be improved - and we should definitely not
> extend the list of exclusions.

Yup, agreed.
