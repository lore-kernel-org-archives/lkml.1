Return-Path: <linux-kernel-owner+w=401wt.eu-S1757643AbZKERs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643AbZKERs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 12:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756598AbZKERs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 12:48:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755299AbZKERs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 12:48:27 -0500
Date: Thu, 5 Nov 2009 09:47:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jiri Kosina <jkosina@suse.cz>
cc: Michael Gilbert <michael.s.gilbert@gmail.com>,
       Michael Buesch <mb@bu3sch.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: CVE-2009-2584
In-Reply-To: <alpine.LFD.2.01.0911050923580.31845@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0911050945070.31845@localhost.localdomain>
References: <20091104170542.e40b12ec.michael.s.gilbert@gmail.com> <alpine.LRH.2.00.0911051620510.31913@twin.jikos.cz> <alpine.LFD.2.01.0911050831330.31845@localhost.localdomain> <alpine.LFD.2.01.0911050923580.31845@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 5 Nov 2009, Linus Torvalds wrote:
>  {
> -	unsigned long val;
> -	char buf[80];
> +	char buf[16];

On third thought, this was too aggressive.

Using "0x%16ul" as a format on 64-bit machines is reasonable, so 19 bytes 
of buffer is not insane (with the terminating NUL). Of course, it never 
used to accept hex numbers, so it's not like it would have worked before, 
but the point is that I cut down the buffer unnecessarily strictly.

Can anybody see anything else wrong in that suggested fix?

		Linus
