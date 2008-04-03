Return-Path: <linux-kernel-owner+w=401wt.eu-S1761067AbYDCF6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761067AbYDCF6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 01:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757409AbYDCF5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 01:57:52 -0400
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:27894 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757360AbYDCF5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 01:57:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=rJY3K+tmyXwMcWOPTLmNNj69EXZXa2/Q2CGPAFi7Mj5FVvAl7tSmkhqmlKRjKflpvVa9SZr2UM6tCkOqiruOsCKpbDI3REB7w8d/mqMzIIizgOSTVx2iujQXXEaDq5v6kymd+vj7zvtpz2oDc24sV8hrDx+5xWt/d9arrLfyRxI=  ;
X-YMail-OSG: FgBafjgVM1nF.A7yudaTZTDw3rFo8GiMdFgcgVlJQLr1dcVmNEyWz_PmbcSsMjNKCLmaW266WQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: GFP_ATOMIC page allocation failures.
Date: Thu, 3 Apr 2008 16:57:43 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Snook <csnook@redhat.com>,
       Dave Jones <davej@codemonkey.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20080401235609.GA6947@codemonkey.org.uk> <20080402103355.77ef22ff.akpm@linux-foundation.org> <47F3CE10.1060903@garzik.org>
In-Reply-To: <47F3CE10.1060903@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804031657.43895.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 April 2008 05:18, Jeff Garzik wrote:

> Turning to Nick's comment,
>
> > It's still actually nice to know how often it is happening even for
> > these known good sites because too much can indicate a problem and
> > that you could actually bring performance up by tuning some things.
>
> then create a counter or acculuation buffer somewhere.
>
> We don't need spew every time there is memory pressure of this magnitude.

Not a complete solution. Counter would be nice, but you need backtraces
and want a way to more proactively warn the user/tester/developer.

I agree that I don't exactly like adding nowarns around, and I don't think
places like driver writers should have to know about this stuff.


> IMO there are much better ways than printk(), to inform tasks, and
> humans, of allocation failures.

I think with a tweaked warning message, a ratelimited printk is OK.
