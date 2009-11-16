Return-Path: <linux-kernel-owner+w=401wt.eu-S1752088AbZKPIIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbZKPIIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 03:08:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbZKPIIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 03:08:06 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:41505 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbZKPIIG convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;4:1>);
	Mon, 16 Nov 2009 03:08:06 -0500
Message-Id: <4B011677020000780001FD9D@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 16 Nov 2009 08:08:07 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Nick Piggin" <npiggin@suse.de>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
       <hpa@zytor.com>
Subject: Re: [PATCH] x86: eliminate redundant/contradicting cache line
	 size config options
References: <4AFD5710020000780001F8F0@vpn.id2.novell.com>
 <20091116041407.GB5818@wotan.suse.de>
In-Reply-To: <20091116041407.GB5818@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Nick Piggin <npiggin@suse.de> 16.11.09 05:14 >>>
>On Fri, Nov 13, 2009 at 11:54:40AM +0000, Jan Beulich wrote:
>> Rather than having X86_L1_CACHE_BYTES and X86_L1_CACHE_SHIFT (with
>> inconsistent defaults), just having the latter suffices as the former
>> can be easily calculated from it.
>> 
>> To be consistent, also change X86_INTERNODE_CACHE_BYTES to
>> X86_INTERNODE_CACHE_SHIFT, and set it to 7 (128 bytes) for NUMA to
>> account for last level cache line size (which here matters more than
>> L1 cache line size).
>
>I think if we're going to set it to 7 (128B, for Pentium 4), then
>we should set the L1 cache shift as well? Most alignments to
>prevent cacheline pingpong use L1 cache shift for this anyway?

But for P4 L1_CACHE_SHIFT already is 7.

>The internode thing is really just a not quite well defined thing
>because internode cachelines are really expensive and really big
>on vsmp so they warrant trading off extra space on some critical
>structures to reduce pingpong (but this is not to say that other
>structures that are *not* internode annotated do *not* need to
>worry about pingpong).

The internode one, as said in the patch description, should consider
the last level cache line size rather than L1, which 128 seems to be
a much better fit (without in introducing model dependencies like
for L1) than just using the L1 value directly.

Jan

