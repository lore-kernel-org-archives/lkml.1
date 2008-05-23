Return-Path: <linux-kernel-owner+w=401wt.eu-S1763260AbYEWFY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763260AbYEWFY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 01:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbYEWFYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 01:24:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:64709 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbYEWFYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 01:24:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=krSIWGvNOFG9tq+E5yNjsFDRPGfN8E2l5DJ5/tvBdGzq/WUMvuy90P/E4xlpq5qbDLGZPHWJdh2S4hG/CUxfVWsrhnPSkQhAJmCNkGSoS2shVuNvON2aoEqdW3zy2JH1WJ+lt9Rk2MDPlvOBtiFOPw7fKKFwg+tw7KWo/v1ci7Y=
Message-ID: <3877989d0805222224n77ce36b6wdf15c4bab330a0f8@mail.gmail.com>
Date: Fri, 23 May 2008 13:24:44 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Roland McGrath" <roland@redhat.com>
Subject: Re: [RFC PATCH] set TASK_TRACED before arch_ptrace code to fix a race
Cc: "Petr Tesarik" <ptesarik@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
In-Reply-To: <20080523041940.39E8726FA24@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3877989d0805211947i54bacc7cv619541e9b40824fb@mail.gmail.com>
	 <1211446045.5610.33.camel@elijah.suse.cz>
	 <3877989d0805220216o5add20ddye2a1fde98a0c1e69@mail.gmail.com>
	 <20080522111826.BB90326FA24@magilla.localdomain>
	 <3877989d0805220624i259a9d1j708795c65c636ca0@mail.gmail.com>
	 <20080522203428.835D626FA24@magilla.localdomain>
	 <3877989d0805222042p176da844k384ea512b1cfb0da@mail.gmail.com>
	 <20080523041940.39E8726FA24@magilla.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is the key thing that makes no sense to me.  What do you mean by
> "deliver" here?  The normal meaning of to "deliver" a signal means that
> get_signal_to_deliver() dequeues and processes it.  This can never happen
> inside any other kernel code path.  It certainly can never happen inside
> ptrace_stop or ptrace_notify.

"deliver" here I mean get_signal_to_deliver()...
Please clarify, in ptrace_notify code path, is it allowed that ptraced
thread can ignore signals (such as SIGTRAP) without telling debugger
what happened? This is key problem I'm not quite sure... Because if
the test doesn't block SIGTRAP, it works on IA64 too.. Hope I have
made the problem clear...
