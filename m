Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbZKWOtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbZKWOtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 09:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbZKWOtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 09:49:20 -0500
Received: from casper.infradead.org ([85.118.1.10]:37123 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbZKWOtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 09:49:20 -0500
Date: Mon, 23 Nov 2009 06:51:08 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       alan@linux.intel.com
Subject: Re: [patch] timer: Add a mod_timer_msec() API function
Message-ID: <20091123065108.1fd78779@infradead.org>
In-Reply-To: <20091123082648.GB13186@elte.hu>
References: <20091122154111.197e1a8a@infradead.org>
	<20091123082648.GB13186@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009 09:26:48 +0100
Ingo Molnar <mingo@elte.hu> wrote:
> 
> This code first rounds to 1 second - and if that doesnt fall within
> the slack window it rounds to the (rather aribtrary) rounding of 16
> jiffies.
> 
> I'd suggest to use up the slack to its maximum, by rounding up modulo 
> the largest power-of-2 value that still fits into the slack.
> 
> So if slack is 30, the rounding is 16. If slack is 5, the rounding is
> 4, etc.

well.. the point of the rounding is that there is a maximum likelyhood
that OTHER timers align.

I suppose what you suggest would do that too; need to think of a clever
way to not make that expensive
(after coffee I'll look at if xor + find first bit will work ;-)

> 
> 	Ingo


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
