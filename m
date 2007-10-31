Return-Path: <linux-kernel-owner+w=401wt.eu-S1760638AbXJaQbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760638AbXJaQbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 12:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758035AbXJaQbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 12:31:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42940 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760562AbXJaQbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 12:31:13 -0400
Date: Wed, 31 Oct 2007 09:31:00 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use 64bit timer values while calibrating BogoMips
Message-ID: <20071031093100.3a1542b0@laptopd505.fenrus.org>
In-Reply-To: <200710311652.16776.ak@suse.de>
References: <200710311652.16776.ak@suse.de>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2007 16:52:16 +0100
Andi Kleen <ak@suse.de> wrote:

> 
> When calibrating BogoMips 32bit architectures using 
> read_current_timer will truncate the timer value to 32bit.
> This is a problem on x86 when the TSC timer is already beyond
> 2^32-1 or wraps during the calibration. The current code
> has no wrap handling.  
> 
> This could potentially lead to wrong BogoMips, causing 
> incorrect delays e.g. in hardware drivers and then difficult
> to track down bugs.

bogomips tends to not be used for that nowadays
> 
> Change read_current_timer() to always return a 64bit
> value even on 32bit and do the computation in 64bit.
> 
> Only found by code inspection; i haven't seen a failure 
> in the wild.
> 
> avr32/sparc64 read_current_timer() updated, but I haven't 
> compiled/tested them.

one general comment, if you really want 64 bit... you're using
"unsigned long long" all over, just use u64 instead.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
