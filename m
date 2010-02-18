Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab0BRSOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:14:37 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:36928 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab0BRSOc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:14:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FzGyTHY8laqPnNNxF+RcI+48gpmtYT691Rg8gcXMVMny9eaGhgTgwuolhWQjW4//Xi
         D9eIXd8UlrdVzn1Zvm8IclizG5QiCznSixkqwnoc7YsotRySRZZT+8QaEItbSq7v5uqL
         8vSARwSrelxAaWWOWbloRRJMNQ+mi9V26hp6c=
MIME-Version: 1.0
In-Reply-To: <4B7D5BB4.4000307@zytor.com>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
	 <1266406962-17463-10-git-send-email-luca@luca-barbieri.com>
	 <87eikj54wp.fsf@basil.nowhere.org>
	 <ff13bc9a1002180153g308b0f3dxb59959936d1e343b@mail.gmail.com>
	 <20100218101156.GE5964@basil.fritz.box>
	 <ff13bc9a1002180227j70e0748ag49d88c3034e3900d@mail.gmail.com>
	 <4B7D5BB4.4000307@zytor.com>
Date: Thu, 18 Feb 2010 19:14:30 +0100
X-Google-Sender-Auth: 7e1c8f7f7e1235a7
Message-ID: <ff13bc9a1002181014x5625f418j69f9702bc54c6381@mail.gmail.com>
Subject: Re: [PATCH 09/10] x86-32: use SSE for atomic64_read/set if available
From: Luca Barbieri <luca@luca-barbieri.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is what kernel_fpu_begin/kernel_fpu_end is all about.  We
> definitely cannot leave TS cleared without the user space CPU state
> moved to its home location, or we have yet another complicated state to
> worry about.

It should be relatively simple to handle, since the current code
doesn't really rely on the TS flag but uses TS_USEDFPU.
It would mostly be a matter of making sure TS is restored on return to
userspace if necessary.

> I really feel that without a *strong* use case for this, there is
> absolutely no point.
For the specific 32-bit atomic64_t case, it is an improvement, but not
necessarily significant in the big picture.
Being able to efficiently use SSE in the kernel might however be more
broadly useful.
memcpy/memset/etc. (assuming SSE is the best option for these at least
on some processors) and checksums come to mind.
Also non-temporal SSE moves might be useful for things like memory
compaction without clobbering caches.
