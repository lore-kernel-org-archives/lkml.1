Return-Path: <linux-kernel-owner+w=401wt.eu-S1753749AbYCQFTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbYCQFTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 01:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbYCQFTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 01:19:17 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:40443 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbYCQFTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 01:19:16 -0400
Date: Mon, 17 Mar 2008 10:49:56 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: "Yakov Lerner" <iler.ml@gmail.com>
Cc: prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Subject: kprobes-x86: correct post-eip value in
	post_hander()
Message-ID: <20080317051956.GB7229@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <E1Jao7N-0005OC-Fe@io.site5.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Jao7N-0005OC-Fe@io.site5.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 16, 2008 at 03:21:21AM -0500, Yakov Lerner wrote:
> 
> I was trying to get the address of instruction to be executed 
> next after the kprobed instruction.  But regs->eip in post_handler()
> contains value which is useless to the user. It's pre-corrected value.
> This value is difficult to use without access to resume_execution(), which
> is not exported anyway.
> I moved the invocation of post_handler() to *after* resume_execution().
> Now regs->eip contains meaningful value in post_handler().
> 
> I do not think this change breaks any backward-compatibility.
> To make meaning of the old value, post_handler() would need access to
> resume_execution() which is not exported.  I have difficulty to believe
> that previous, uncorrected, regs->eip can be meaningfully used in
> post_handler().

resume_execution() exists not just for the program counter fixups after
out-of-line singlestepping, but is also as an insurance to put the
program counter back to the correct address in case the user's
post_handler() mucks around with it. That isn't possible with this
change :-(

Ananth
