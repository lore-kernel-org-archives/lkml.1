Return-Path: <linux-kernel-owner+w=401wt.eu-S1757959AbZFWD07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959AbZFWD07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 23:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbZFWD0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 23:26:50 -0400
Received: from n26.bullet.mail.mud.yahoo.com ([68.142.206.221]:35060 "HELO
	n26.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751372AbZFWD0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 23:26:49 -0400
X-Yahoo-Newman-Id: 473108.61758.bm@omp422.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Ymqu0ORKIUYVMvlXdJ42WtuLbJk1LVtCwDGAOtSsCiz35tZ4r07I2trYD0xyuTaWOhzT6LPMo3m5OHHyh35WaCWUHx+EAqcR5NcvTqgMfe8oFM+h8eb4a0Sw+NCOutX5qEH30Lbo/Mx5OdNMb12cNhkPD8lAoouw/Nc30KSzcwQ=  ;
X-YMail-OSG: 3mOnKBYVM1mxk5XqyDXGY5zp1XDZHnj_5JjSFLUdeblQSeSYIojW4MfJmv9VOEXHZWN0bb5Og6_0_g4EoRx.l.lDNYOxZyoowu5PSygjqjEgsnXscVynU4lU_QpoTB6..ozkd11wFKSNNPHElNL68enhpf_1RbOdANZGZk3IQjWIBlRkKEDp7MR4radG1bciizAk5.Ec4_ISyULJKDTSgJHKVZ5_ZH93V5BPnqb7PCwK2VHDhHxVjk6hhbjyELT98_wu0enjF19WOkXn
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: PROBLEM: kernel oops with g_serial USB gadget on 2.6.30
Date: Mon, 22 Jun 2009 20:26:51 -0700
User-Agent: KMail/1.9.10
Cc: "'Alan Stern'" <stern@rowland.harvard.edu>,
       "'Peter Korsgaard'" <jacmet@sunsite.dk>,
       "'USB list'" <linux-usb@vger.kernel.org>,
       "'Kernel development list'" <linux-kernel@vger.kernel.org>,
       kyungmin.park@samsung.com
References: <001201c9f341$20b8b710$622a2530$%szyprowski@samsung.com> <Pine.LNX.4.44L0.0906221004590.2991-100000@iolanthe.rowland.org> <001301c9f343$7e16ed80$7a44c880$%szyprowski@samsung.com>
In-Reply-To: <001301c9f343$7e16ed80$7a44c880$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200906222026.51511.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 June 2009, Marek Szyprowski wrote:
> 
> > This is just a guess...  But there's a good possibility that the oops
> > was caused by recent changes to the serial layer which have not been
> > propagated through to the g_serial driver.
> 
> How recent these changes are? I did a test on another ARM-based Linux 
> platform with old 2.6.28 kernel and the result was exactly the same as 
> above...

Just for the record, the reworked g_serial code merged in 2.6.27
and was mostly developed on 2.6.25 and 2.6.26 ... and it included
a lot of stress testing.  No such mutex_lock() in_irq() bug showed
up at that time.  And that was running with all practical kernel
debug options, so it should have showed up if it were that easy.

I do however recall turning up several regressions in how "sparse"
lock checking behaved.  As in, it broke when faced with common
idioms like needing to temporarily drop a lock deep in a call stack.

Now, the serial layer has been getting a *LONG* overdue incremental
overhaul since before that started.  So there's been plenty of time
for incompatible changes to sneak in; I believe Alan Cox focuses on
host side things, out of defensive necessity.

Like, oh, changing a spinlock to a mutex.   You might change the
low_latency setting and review how that's now supposed to behave.

- Dave


