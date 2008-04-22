Return-Path: <linux-kernel-owner+w=401wt.eu-S1756981AbYDVSJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981AbYDVSJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 14:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755591AbYDVSJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 14:09:19 -0400
Received: from sandeen.net ([209.173.210.139]:31639 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703AbYDVSJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 14:09:19 -0400
Message-ID: <480E29CD.1010203@sandeen.net>
Date: Tue, 22 Apr 2008 13:09:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Ingo Molnar <mingo@elte.hu>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix  max-stack calculators to skip canary
References: <480D5F27.1030101@redhat.com> <20080422084404.GA2388@elte.hu>	 <480E15DC.5040301@sandeen.net>  <480E1DED.9040104@sandeen.net> <1208885594.8636.23.camel@localhost>
In-Reply-To: <1208885594.8636.23.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:

> Wouldn't it be better to have exactly the same code?
> How about using a statement expression macro?
> 
> #define DEBUG_STACK_FREE(process) \
> ({ \
> 	unsigned long *n = end_of_stack(process); \
> 	do { 	/* Skip over canary */\
> 		n++; \
> 	} while (!*n); \
> 	(unsigned long)n - (unsigned long)end_of_stack(process); \
> })
> 

That'd probably be good although I don't think we like macros anymore :)

-Eric
