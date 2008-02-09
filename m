Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbYBIW3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbYBIW3d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 17:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757007AbYBIW3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 17:29:20 -0500
Received: from mail.gmx.net ([213.165.64.20]:49542 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757422AbYBIW3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 17:29:18 -0500
X-Authenticated: #36809985
X-Provags-ID: V01U2FsdGVkX1+7RQxiS1+7XeAjjqMNngX4jjZbvub5T2GSBbiwAB
	xnHTIiQmY71msc
Subject: Re: [PATCH] time: Fix constant size in kernel/timeconst.h
From: Johann Felix Soden <johfel@gmx.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <47AE1C1F.2070304@zytor.com>
References: <1202563242.22512.1.camel@localhost>
	 <47AE1C1F.2070304@zytor.com>
Content-Type: text/plain
Date: Sat, 09 Feb 2008 23:29:11 +0100
Message-Id: <1202596152.22512.34.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Johann Felix Soden wrote:
> > kernel/timeconst.pl generates only long sized constants in timeconst.pl
> > which gives this warning:
> > 
> > kernel/time.c: In function 'msecs_to_jiffies':
> > kernel/time.c:472: warning: integer constant is too large for 'long' type
> > 
> > unsigned long long is needed.
> Hm, you've just taken a warning and elevated it to a bug.
> 
> According to the C standard, a constant has the shortest type (>= int) 
> needed to hold the constant, and the warning above is somewhat bogus in 
> that context (what version of gcc is that, anyway?)
> 
> ULL is only appropriate to 32-bit machines, or there will be other 
> issues downstream.  The Right Way[TM] to do this would be to get Linux 
> to have the [U]INTxx_C() macros from C99.
> 
> 	-hpa

Sorry for this. Thanks for teaching about the C standard.
About your question: gcc 4.2.3 gave me this warning.
And I'm a little bit surprised because the kernel code is full of
constants with ULL. Is kernel/time.c a special case?

J. F. Soden


