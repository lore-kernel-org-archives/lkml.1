Return-Path: <linux-kernel-owner+w=401wt.eu-S1757073AbYBIVea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073AbYBIVea (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 16:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756786AbYBIVeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 16:34:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35554 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756781AbYBIVeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 16:34:12 -0500
Message-ID: <47AE1C1F.2070304@zytor.com>
Date: Sat, 09 Feb 2008 13:33:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Johann Felix Soden <johfel@gmx.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] time: Fix constant size in kernel/timeconst.h
References: <1202563242.22512.1.camel@localhost>
In-Reply-To: <1202563242.22512.1.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johann Felix Soden wrote:
> From: Johann Felix Soden <johfel@users.sourceforge.net>
> 
> kernel/timeconst.pl generates only long sized constants in timeconst.pl
> which gives this warning:
> 
> kernel/time.c: In function 'msecs_to_jiffies':
> kernel/time.c:472: warning: integer constant is too large for 'long' type
> 
> unsigned long long is needed.
> 

Hm, you've just taken a warning and elevated it to a bug.

According to the C standard, a constant has the shortest type (>= int) 
needed to hold the constant, and the warning above is somewhat bogus in 
that context (what version of gcc is that, anyway?)

ULL is only appropriate to 32-bit machines, or there will be other 
issues downstream.  The Right Way[TM] to do this would be to get Linux 
to have the [U]INTxx_C() macros from C99.

	-hpa

