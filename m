Return-Path: <linux-kernel-owner+w=401wt.eu-S1752034AbXEXRuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbXEXRuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbXEXRtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:49:53 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:34240
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbXEXRtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:49:52 -0400
From: Rob Landley <rob@landley.net>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: Status of CONFIG_FORCED_INLINING?
Date: Thu, 24 May 2007 13:47:43 -0400
User-Agent: KMail/1.9.1
Cc: Adrian Bunk <bunk@stusta.de>, Arjan van de Ven <arjan@linux.intel.com>,
       linux-kernel@vger.kernel.org
References: <200705231510.52932.rob@landley.net> <20070524171019.GA4470@stusta.de> <ada3b1m87pa.fsf@cisco.com>
In-Reply-To: <ada3b1m87pa.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705241347.43727.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 May 2007 1:14 pm, Roland Dreier wrote:
>  > A function only belongs into a header file if we always want it inlined, 
>  > otherwise it belongs into a C file.
> 
> Again, why?  Why don't we trust the compiler to decide if a function
> should be inlined or not, even if the definition happens to be in a .h
> file?

Because the purpose of .h files is to be included in more than one .c file.  
(Otherwise it should be a .c file.)

And if you #include a non-inlined definition in two .c files, the compiler 
will emit two copies into two separate .o files.  What you're hoping is that 
the linker will notice they're identical and merge them, and last I checked I 
couldn't even reliably get it to do that with constant strings.

> It seems like a perfectly valid optimization for the compiler to only
> emit code once for a function and then call it where it is used, even
> if that function happens to be defined in a .h file.

If we put it in a header, it's because we want it inlined.  If we don't want 
it inlined it SHOULDN'T BE IN THE HEADER.

If the compiler can emit a warning "inline insanely large", we can use that to 
fix it.  But a warning is not the same as silently doing something other than 
what we told it to do.

>  - R.

Rob
