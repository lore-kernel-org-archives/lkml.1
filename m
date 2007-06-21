Return-Path: <linux-kernel-owner+w=401wt.eu-S1753120AbXFUC5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbXFUC5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 22:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbXFUC4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 22:56:55 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:46795 "EHLO
	asav03.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbXFUC4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 22:56:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AusRAGGFeUZKhRO4R2dsb2JhbACPEgEBGw0GEQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: Jiri Kosina <jikos@jikos.cz>
Subject: Re: [PATCH] blink: Only blink when parameter is set
Date: Wed, 20 Jun 2007 22:56:52 -0400
User-Agent: KMail/1.9.3
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20070617083904.GC4496@suse.de> <20070621002034.GA18143@elf.ucw.cz> <Pine.LNX.4.64.0706210222390.3068@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0706210222390.3068@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706202256.53850.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 June 2007 20:24, Jiri Kosina wrote:
> On Thu, 21 Jun 2007, Pavel Machek wrote:
> 
> > > this has probably been already solved by proper throttling - see 
> > > http://lkml.org/lkml/2007/6/15/22
> > No, it was not. I still saw the problems with CONFIG_BLINK on, that is
> > one blink per 5 seconds or something.

Pavel, does my patch fixes keyboard issues for you when blinking via
setleds?

> > We should rename CONFIG_BLINK to
> > CONFIG_BREAK_THINKPAD_KEYBOARD_AND_MORE.

Also CONFIG_KILL_MY_NOHZ_SAVINGS ;)

> 
> In fact it looks quite weird that one blink per 5 seconds can break the 
> keyboard, in fact.

Not wierd at all. The driver uses panic_blink - something that we expect
to work after panic. It rapidly polls KBC status register to detect when
it accepted led command and does it without taking i8042_lock (because
it may have been taken before kernel panicked) so it is quite possible
that that interferes with atkbd operation.

IOW I am not really interested in reports regrading issues with keyboards
and/or mice on boxes with blink driver loaded.

-- 
Dmitry
