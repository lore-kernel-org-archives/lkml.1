Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbXERGUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbXERGUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 02:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbXERGU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 02:20:28 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1818 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbXERGU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 02:20:27 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 17 May 2007 23:20:05 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Davi Arnaut <davi@haxent.com.br>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] timerfd/eventfd context lock doesn't protect against
 poll_wait
In-Reply-To: <464D2142.3070705@haxent.com.br>
Message-ID: <Pine.LNX.4.64.0705172258400.5705@alien.or.mcafeemobile.com>
References: <464D2142.3070705@haxent.com.br>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007, Davi Arnaut wrote:

> Hi,
> 
> poll_wait() callback may modify the waitqueue without holding the
> context private lock.

Thx Davi, patch is correct. Nice catch. But at this point instead of 
ending up getting two locks, we may look into using Andrew suggestion of 
reusing the waitqueue lock. Is it universally considered a "legal" 
operation?


- Davide


