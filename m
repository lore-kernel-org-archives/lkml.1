Return-Path: <linux-kernel-owner+w=401wt.eu-S1755232AbZB1Sk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232AbZB1Sk0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 13:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbZB1SkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 13:40:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:60332 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbZB1SkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 13:40:14 -0500
Date: Sat, 28 Feb 2009 10:39:58 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Salman Qazi <sqazi@google.com>,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
Message-ID: <20090228103958.41fce55b@infradead.org>
In-Reply-To: <20090228182759.GA28865@elte.hu>
References: <20090224020304.GA4496@google.com>
	<200902272305.01867.nickpiggin@yahoo.com.au>
	<20090228082922.GB11425@elte.hu>
	<200902282249.57479.nickpiggin@yahoo.com.au>
	<20090228125816.GA14917@elte.hu>
	<alpine.LFD.2.00.0902280904271.3111@localhost.localdomain>
	<20090228092450.3ded2db5@infradead.org>
	<alpine.LFD.2.00.0902280935010.3111@localhost.localdomain>
	<20090228182759.GA28865@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Feb 2009 19:27:59 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> OTOH, given how draconian non-temporal stores are, i'm leaning 
> towards removing them from the x86 code altogether. If it matter 
> to performance somewhere it can be reintroduced, based on really 
> well backed up numbers.

I think that is mostly the right approach; O_DIRECT could be the
exception to that (because there we don't only wipe it from the cpu
cache due to DMA, it even gets wiped from the pagecache!).
But I can see that being too special of a case to care about in the
grand scheme of things (although the database people will now get upset
with me ;-)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
