Return-Path: <linux-kernel-owner+w=401wt.eu-S1756990AbYCKGyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990AbYCKGyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 02:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYCKGxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 02:53:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42746 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbYCKGxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 02:53:52 -0400
Message-ID: <47D62A0D.3070107@zytor.com>
Date: Tue, 11 Mar 2008 07:43:25 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: P6 NOPs again: MPSC?
References: <Pine.LNX.4.64.0803041929230.14934@blonde.site> <20080304210111.GB31546@elte.hu> <47CDBE09.3060000@zytor.com> <Pine.LNX.4.64.0803101853090.15511@blonde.site> <47D59743.7040709@zytor.com> <Pine.LNX.4.64.0803102142440.2464@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0803102142440.2464@blonde.site>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> 
> Yup, I realized that (with || in place of &&): I meant that perhaps
> it was supposed to say X86_64 || (!X86_GENERIC && (M686 || ....))
> since quite a lot of other options there have "|| X86_64" to cover
> all the 64-bit possibilities at once i.e. is it only MPSC that
> needs to be added, or both MPSC and CPU_GENERIC?
> 

No.  The left-hand clause (X86_64 || !X86_GENERIC) indicates when using 
these NOPs are *permitted*; the right-hand clause indicates when doing 
so is *desirable*.  The latter isn't, for example, for K8, even on 64 bits.

	-hpa

