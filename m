Return-Path: <linux-kernel-owner+w=401wt.eu-S1758462AbZGCSVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462AbZGCSVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 14:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756472AbZGCSVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 14:21:42 -0400
Received: from [76.245.85.235] ([76.245.85.235]:46067 "EHLO cynthia.pants.nu"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756534AbZGCSVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 14:21:42 -0400
X-Greylist: delayed 2445 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Jul 2009 14:21:42 EDT
Date: Fri, 3 Jul 2009 10:40:31 -0700
From: Brad Boyer <flar@allandria.com>
To: kernel mailz <kernelmailz@googlemail.com>
Cc: linuxppc-dev@ozlabs.org, gcc-help@gcc.gnu.org,
       linux-kernel@vger.kernel.org
Subject: Re: Inline assembly queries [2]
Message-ID: <20090703174031.GA12410@cynthia.pants.nu>
References: <abe8a1fd0907022344k2eb9874ejdbda3209a7cadf40@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abe8a1fd0907022344k2eb9874ejdbda3209a7cadf40@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 12:14:41PM +0530, kernel mailz wrote:
> Thanks for responding to my previous mail. A few more queries
> 
> a. What is the use of adding format specifiers in inline assembly
> like
> asm volatile("ld%U1%X1 %0,%1":"=r"(ret) : "m"(*ptr) : "memory");

The format specifiers limit which registers or addressing modes will
be chosen to access that parameter. For example, if you're using an
instruction that treats r0 as a literal 0 value, you can't use the
"r" specifier for that or you may see problems if it happens to allocate
r0 for that particular argument. For memory access, the "m" lets you
use any of the normal load/store patterns (which is why this particular
choice also requires the "%U1%X1" part to allow changing the instruction).
The system was setup for an older style chip like x86 or 68k with many
restrictions on which registers can be used where and large numbers of
different addressing modes for accessing memory. It's a little clumsy
for ppc by comparison to most other chips, but it's a fundamental part
of inline assembly processing in gcc.

> b. using m or Z  with a memory address. I tried replacing m/Z but no change
> Is there some guideline ?
> gcc documentation says Z is obsolete. Is m/Z replaceable ?

No idea. I don't remember ever seeing 'Z' used in anything. Maybe somebody
else remembers what it used to mean.

	Brad Boyer
	flar@allandria.com

