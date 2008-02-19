Return-Path: <linux-kernel-owner+w=401wt.eu-S1756969AbYBSOWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969AbYBSOWD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 09:22:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbYBSOVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 09:21:53 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:27257 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbYBSOVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:21:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=fnrDEJGbwTvuT1ke5RK4GtIBE7uDeQMPaCanExOFzytHmbAMxxIqeFBI2UQJ9Wnw4bYE+pyw/eBHt1C7efuoEW+aBOyNsrcv8OvrlDqHImP7uzte/Wrqmfe/UAMJbpbSn26pAbrBD2bMxjlfNRtsR6d+cgBmnPZw8Bk0yUDfQqw=
Message-ID: <84144f020802190621s509dbe7gc8e5609d94aca9b4@mail.gmail.com>
Date: Tue, 19 Feb 2008 16:21:51 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>
Subject: Re: Linux 2.6.25-rc2
Cc: "Torsten Kaiser" <just.for.lkml@googlemail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <20080219140230.GA32236@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>
	 <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com>
	 <20080219061107.GA23229@elte.hu>
	 <64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com>
	 <84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com>
	 <20080219140230.GA32236@Krystal>
X-Google-Sender-Auth: d66c46250688e945
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

On Feb 19, 2008 4:02 PM, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> - stat(c, ALLOC_FASTPATH); seems to be using a var++, therefore
>   indicating it is not reentrant if IRQs are disabled. Since those are
>   only stats, I guess it's ok, but still weird.

What is not re-entrant?

On Feb 19, 2008 4:02 PM, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> Since this shows mostly with network card drivers, I think the most
> plausible cause would be an IRQ nesting over kmem_cache_alloc_node and
> calling it.

Yes, this can happen. Are you saying it is not safe to be in the
lockless path when an IRQ triggers?
