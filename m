Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbYCQK7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbYCQK7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 06:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbYCQK7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 06:59:09 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:34603 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbYCQK7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 06:59:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=X/gCZfrDSGxa68xTkswr3N22icuVNMAxzX6srRFH9LCskVQaknYy5JBsxj0xCjoo+zf03o7bshBozP33/wlJR51LcBcycDmV+4EB75frJ29/Tp8mzJNmhihBrqds0q/XIhrvHtHaEe1AnnSycgcVB5g/rTPC66/p/rH7MwC1Lew=
Message-ID: <f36b08ee0803170359w675130bas296b5276da5f2a3d@mail.gmail.com>
Date: Mon, 17 Mar 2008 12:59:05 +0200
From: "Yakov Lerner" <iler.ml@gmail.com>
To: ananth@in.ibm.com
Subject: Re: [PATCH] Subject: kprobes-x86: correct post-eip value in post_hander()
Cc: prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080317051956.GB7229@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1Jao7N-0005OC-Fe@io.site5.com> <20080317051956.GB7229@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 7:19 AM, Ananth N Mavinakayanahalli
<ananth@in.ibm.com> wrote:
> On Sun, Mar 16, 2008 at 03:21:21AM -0500, Yakov Lerner wrote:
>  >
>  > I was trying to get the address of instruction to be executed
>  > next after the kprobed instruction.  But regs->eip in post_handler()
>  > contains value which is useless to the user. It's pre-corrected value.
>  > This value is difficult to use without access to resume_execution(), which
>  > is not exported anyway.
>  > I moved the invocation of post_handler() to *after* resume_execution().
>  > Now regs->eip contains meaningful value in post_handler().
>  >
>  > I do not think this change breaks any backward-compatibility.
>  > To make meaning of the old value, post_handler() would need access to
>  > resume_execution() which is not exported.  I have difficulty to believe
>  > that previous, uncorrected, regs->eip can be meaningfully used in
>  > post_handler().
>
>  resume_execution() exists not just for the program counter fixups after
>  out-of-line singlestepping, but is also as an insurance to put the
>  program counter back to the correct address in case the user's
>  post_handler() mucks around with it. That isn't possible with this
>  change :-(

I see your point. This can be prevented by saving and restoring regs->ip
around the post_handler() call, no ? Current code is beautiful. Saving and
restoring regs->ip would make this place look ugly.

Otoh, if the post_handler() wants to crash the kernel, it can do it
in thousand ways, not just by trashing regs->ip, no ?

Yakov
