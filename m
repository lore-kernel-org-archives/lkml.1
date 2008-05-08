Return-Path: <linux-kernel-owner+w=401wt.eu-S1758944AbYEHU2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944AbYEHU2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 16:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760250AbYEHU2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 16:28:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759266AbYEHU2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 16:28:19 -0400
Date: Thu, 8 May 2008 13:27:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] speed up / fix the new generic semaphore code (fix AIM7
 40% regression with 2.6.26-rc1)
In-Reply-To: <20080508201956.GA2547@elte.hu>
Message-ID: <alpine.LFD.1.10.0805081326130.2940@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org> <alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org> <1210214696.3453.87.camel@ymzhang> <alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org>
 <1210219729.3453.97.camel@ymzhang> <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org> <20080508120130.GA2860@elte.hu> <20080508122802.GA4880@elte.hu> <alpine.LFD.1.10.0805080859140.3024@woody.linux-foundation.org>
 <alpine.LFD.1.10.0805081128550.3024@woody.linux-foundation.org> <20080508201956.GA2547@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 May 2008, Ingo Molnar wrote:
>
> I suspect some more performance could be won in this particular workload 
> by getting rid of the BKL dependency altogether.

Did somebody have any trace on which BKL taker it is? It apparently wasn't 
file locking. Was it the tty layer?

		Linus
