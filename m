Return-Path: <linux-kernel-owner+w=401wt.eu-S1762085AbZJJUES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762085AbZJJUES (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 16:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761525AbZJJUER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 16:04:17 -0400
Received: from vena.lwn.net ([206.168.112.25]:57906 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760152AbZJJUER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 16:04:17 -0400
Date: Sat, 10 Oct 2009 14:03:39 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: John Kacur <jkacur@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Mark Gross <mgross@linux.intel.com>
Subject: Re: [patch 02/28] pm_qos: clean up racy global "name" variable
Message-ID: <20091010140339.5cb5b17b@bike.lwn.net>
In-Reply-To: <alpine.LFD.2.00.0910102147020.3669@localhost.localdomain>
References: <20091010153314.827301943@linutronix.de>
	<20091010153349.113570550@linutronix.de>
	<alpine.LFD.2.00.0910102147020.3669@localhost.localdomain>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Oct 2009 21:54:22 +0200 (CEST)
John Kacur <jkacur@redhat.com> wrote:

> Hmnn, why 32? Seems arbitrary. At least you see with "process_1234567890" 
> which is 19, an attempt to show what the maximum string size would be. If 
> a system were configured to enlarge the maximum PID from 32767 to 4194303 
> that would still only be 7 digits, so "process_1234567" - which is 16 
> digits with the newline would enough.
> 
> So, I suggest you change that to
> #define PID_NAME_LEN sizeof("process_1234567")

...which works great until somebody enables 64-bit process IDs...:)

We're talking about 20 bytes of stack space in an almost-never-called
function. I honestly don't think it's worth worrying about, but if
somebody wants to tweak it, I'll not complain.

(Thanks for looking at the patch).

jon
