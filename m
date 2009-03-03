Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbZCCJ2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbZCCJ2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 04:28:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbZCCJ14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 04:27:56 -0500
Received: from viefep13-int.chello.at ([62.179.121.33]:64496 "EHLO
	viefep13-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbZCCJ14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 04:27:56 -0500
X-SourceIP: 213.93.53.227
Subject: Re: lockdep and threaded IRQs (was: ...)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Brownell <david-b@pacbell.net>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       me@felipebalbi.com, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, felipe.balbi@nokia.com,
       dmitry.torokhov@gmail.com, sameo@openedhand.com, tglx@linutronix.de
In-Reply-To: <200903021837.08635.david-b@pacbell.net>
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com>
	 <200903021633.08736.david-b@pacbell.net> <20090303004427.GA8638@elte.hu>
	 <200903021837.08635.david-b@pacbell.net>
Content-Type: text/plain
Date: Tue, 03 Mar 2009 10:27:26 +0100
Message-Id: <1236072446.18955.44.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 18:37 -0800, David Brownell wrote:
> No.  But I did get a non-response that didn't include any
> explanation, and relied totally on unfounded assertions
> combined with the presumption that someday IRQF_DISABLED
> will be forced on in all drivers.

Enabling IRQs in hardirq context is BAD because:

 - IRQ handler nesting leads to stack overflow
 - It gives the false impression its OK for IRQ handlers to be slow,
   it is _NOT_, as you still generate horrible preemption latency.

Therefore IRQF_DISABLED _will_ be forced on everybody some day soon, and
I'll provide an IRQF_ENABLED for use by broken hardware only (and make a
TAINT flag for that too).



