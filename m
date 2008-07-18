Return-Path: <linux-kernel-owner+w=401wt.eu-S1756939AbYGRJPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbYGRJPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 05:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbYGRJP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 05:15:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:43016 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182AbYGRJP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 05:15:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=xGFQwR1jR3YKMWX5YYCoWqktukSTEeAbx+1SuArIQ8hka7a7V3TpzOd2o4pOVZCFV7
         DIGazhUBDeXqx9sqkh+ZAAfPngptFsBYdJ/qC9OIbxRYnsLMDRb+SNoafRSKymr7Mtyo
         Hq0lkk8VnKWV2Vfy93C2wetyXsLSEahtrduKs=
Message-ID: <84144f020807180215p4c3e9fadl75c478f1aacea35f@mail.gmail.com>
Date: Fri, 18 Jul 2008 12:15:26 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [bug, netconsole, SLUB] BUG skbuff_head_cache: Poison overwritten
Cc: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20080718090951.GP6875@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080717214222.GA29449@elte.hu>
	 <20080718054626.GA3338@2ka.mipt.ru>
	 <84144f020807180202l6c703234ic3a2b57e73a1d89a@mail.gmail.com>
	 <20080718090951.GP6875@elte.hu>
X-Google-Sender-Auth: 714de48f9f8ffef0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Fri, Jul 18, 2008 at 12:09 PM, Ingo Molnar <mingo@elte.hu> wrote:
> yeah, we want to check use-after free at the next allocation point -
> i.e. as late as possible to gather all corruptions that happened
> meanwhile.
>
> We could in theory have a SLUB debug mode where a SCHED_IDLE kernel
> thread would periodically check all free objects (of that CPU) in the
> background to ensure their integrity. That would catch corruptions
> sooner, with a possibly still meaningful context to print out. [right
> after the IRQ or process that corrupts them finishes running]
>
> It could also be hooked into ftrace to print out the last few hundred
> kernel function calls executed prior any corruption. ftrace/slub-debug
> plugin perhaps?

Well, there's this Norwegian guy, Vegard, who has written a small
piece of code that can detect use-after-free _as it happens_. I think
he calls the thing kmemcheck :-).
