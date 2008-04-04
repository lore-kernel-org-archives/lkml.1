Return-Path: <linux-kernel-owner+w=401wt.eu-S1757439AbYDDK5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbYDDK5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 06:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbYDDK5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 06:57:38 -0400
Received: from oss.sgi.com ([192.48.170.157]:38362 "EHLO oss.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbYDDK5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 06:57:38 -0400
Date: Fri, 4 Apr 2008 11:24:07 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       dmitri.vorobiev@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc8-mm1 (mips build failure)
Message-ID: <20080404102407.GA25892@linux-mips.org>
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org> <47F31C46.9000503@gmail.com> <20080401230322.331c50f4.akpm@linux-foundation.org> <Pine.LNX.4.64.0804021031480.26938@schroedinger.engr.sgi.com> <20080402112907.76e1c554.akpm@linux-foundation.org> <Pine.LNX.4.64.0804021130040.28113@schroedinger.engr.sgi.com> <20080402190623.GA23651@uranus.ravnborg.org> <20080403160230.GA17771@linux-mips.org> <Pine.LNX.4.64.0804031515280.8986@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804031515280.8986@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2008 at 03:17:22PM -0700, Christoph Lameter wrote:

> > The reason for MIPS doing things a little different is that the resulting
> > <asm/asm-offsets.h> doesn't look like machine generated jibberish.  So
> > how about below patch which combines the two sed expressions.
> 
> Well but it is machine generated and it may be best if mips would do more 
> of the same that is done in other arches? We do not want special arch 
> cases in Kbuild.
> 
> How about this patch?

Almost.  It compiles into a usable header but breaks the text() macro
which is used to emit a commit (actually any string literal) into the
output:

>  #define text(t) __asm__("\n@@@" t)

>  void output_ptreg_defines(void)
>  {
>  	text("/* MIPS pt_regs offsets. */");

With your patch nothing will be emited.  The existing non-MIPS sed
expression in Kbuild doesn't allow for that which is why I added the
handling of @@@-prefixed strings to the sed expression.  And once that
is there the remaining asm-offset.c change is no longer needed.

  Ralf
