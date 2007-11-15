Return-Path: <linux-kernel-owner+w=401wt.eu-S1762972AbXKOHRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762972AbXKOHRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998AbXKOHRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 02:17:20 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:21971 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751682AbXKOHRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 02:17:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=olvGvAVb5pr07NWUYU/Uehm7M1M4Wq58/RD3DvYQ8YuytZbNy3dNnzieZ0y6XrrNSQtj4iRPwZoB8m5xRzyWQDFQZjUQT3x+0cDXkfyTbKjYYBwpbVKueydMhgLDORTfgqot0ay6Y74oB73ONvURaDN0bo6MzLo50SibRGHYavc=  ;
X-YMail-OSG: iusfRw4VM1mUai2FkgCr3C5GTo_85Y0RLmHdxoWWCVW7DqW_iGVSU8emZdA5Yfptf_PH9hDmzw--
From: David Brownell <david-b@pacbell.net>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
Date: Wed, 14 Nov 2007 22:28:10 -0800
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
References: <200711091136.20051.david-b@pacbell.net> <200711140020.46764.david-b@pacbell.net> <200711140818.59714.nickpiggin@yahoo.com.au>
In-Reply-To: <200711140818.59714.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711142228.10934.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2007, Nick Piggin wrote:
> > All this does is prevent constant and needless checking for
> > "do you want to preempt me now?" "now?" "now?" in "now?" the
> > middle "now?" of "now?" i/o "now?" loops.
> 
> Actually that's wrong.

Certainly it's right for the mainstream kernel.  Dropping a
lock (other than a raw spinlock) does that checking; when a
loop needs to acquire then drop such a lock, that's exactly
what's going on.

And in the RT kernel, it's got to do the same thing ...
because dropping that lock may mean that a higher priority
task should immediately run and grab the lock.

