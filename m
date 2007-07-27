Return-Path: <linux-kernel-owner+w=401wt.eu-S965232AbXG0UPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965232AbXG0UPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 16:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965127AbXG0UOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 16:14:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60800 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965121AbXG0UOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 16:14:01 -0400
Subject: Re: IRQF_DISABLED problem
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, matthew@wil.cx, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.0.999.0707261616050.3442@woody.linux-foundation.org>
References: <20070726201355.GP19275@parisc-linux.org>
	 <20070726.152352.70218024.davem@davemloft.net>
	 <alpine.LFD.0.999.0707261557150.3442@woody.linux-foundation.org>
	 <alpine.LFD.0.999.0707261616050.3442@woody.linux-foundation.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 27 Jul 2007 13:11:56 -0700
Message-Id: <1185567116.2711.2.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-26 at 16:17 -0700, Linus Torvalds wrote:
> 
> On Thu, 26 Jul 2007, Linus Torvalds wrote:
> > 
> >  (c) "one IRQF_DISABLED means that everything runs disabled". This is 
> >      quite possibly buggy.
> 
> (Side note: I'm not claiming this (or it's mirror image (d)) is really any 
> better/worse than the current behaviour from a theoretical standpoint, but 
> at least the current behaviour is _tested_, which makes it better in 
> practice. So if we want to change this, I think we want to change it to 
> something that is _obviously_ better).

my personal preference would actually be to just never enable
interrupts. It's the fastest solution obviously, the most friendly on
stack and.. well simplest. Drivers no longer need to play some of the
games that they do today. And while there is an argument that this may
introduce a bit of latency... I'm not really convinced. The real work if
it's really heavy is supposed to happen in not-hard-irq context anyway,
and for all other cases interrupting the original handler is very likely
the most expensive thing in terms of adding latency to the system.


If I remember correctly there have been a few fedora releases which did
this, with no bad behavior.. I don't know if Fedora still does this.

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

