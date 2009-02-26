Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbZBZUSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbZBZUSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 15:18:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbZBZUSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 15:18:36 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:43649 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbZBZUSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 15:18:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FJfaJAyZfI72W0HvzIBpL2fQt0CJOuMpmVD/ufaAFb2bHifgU7X8GvhlcytzBplKTA
         T34d9TS+HP5AZ96CzlM1TAKgYM7GSaaSCQSJOGNUZSPdZX6K8mHugNvrT2BgGEEMy7yl
         lwwMMNFtrSJn9x8/lUakie9BUjODNorsx0iT4=
MIME-Version: 1.0
In-Reply-To: <20090226191509.GA6204@redhat.com>
References: <20090226184433.GA15644@damson.getinternet.no>
	 <20090226191509.GA6204@redhat.com>
Date: Thu, 26 Feb 2009 21:18:32 +0100
Message-ID: <19f34abd0902261218u388de998l1204857bde9bbe32@mail.gmail.com>
Subject: Re: [RFC][PATCH] signals: don't copy siginfo_t on dequeue
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/26 Oleg Nesterov <oleg@redhat.com>:
> So. dequeue_signal() returns NULL if there is no siginfo queued. In that
> case we assume that the signal is not pending.
>
> But this is not right. Think about SEND_SIG_FORCED, or __sigqueue_alloc()
> failure when the signal is sent. Or look at zap_other_threads() for example,
> it just sets the bit in ->pending but doesn't queue siginfo.

I will investigate. Thanks for looking, and thanks for the pointers :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
