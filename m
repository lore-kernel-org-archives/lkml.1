Return-Path: <linux-kernel-owner+w=401wt.eu-S1763274AbZD1SLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763274AbZD1SLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 14:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760929AbZD1SLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 14:11:23 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:36157 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760898AbZD1SLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 14:11:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsIEAIng9klMQW1W/2dsb2JhbACBUM49g3MF
Date: Tue, 28 Apr 2009 14:11:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86: cleanup alternative.h
Message-ID: <20090428181114.GB2030@Krystal>
References: <20090422201852.092307236@polymtl.ca> <20090422202453.673946867@polymtl.ca> <20090428130501.GC26600@Krystal> <20090428145839.GA26546@elte.hu> <49F73F79.7060809@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <49F73F79.7060809@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:10:41 up 59 days, 14:36,  4 users,  load average: 0.10, 0.27,
	0.32
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Ingo Molnar wrote:
> > 
> > Please try to align both the continuation backslashes and the 
> > comments vertically. Something like:
> > 
> >> +#define ALTERNATIVE(oldinstr, newinstr, feature)			 \
> >> +									 \
> >> +	"661:\n\t" oldinstr "\n662:\n"					 \
> >> +	".section .altinstructions,\"a\"\n"			 	 \
> >> +	_ASM_ALIGN "\n"						 	 \
> >> +	_ASM_PTR "661b\n"			   /* label           */ \
> >> +	_ASM_PTR "663f\n"			   /* new instruction */ \
> >> +	 "	 .byte " __stringify(feature) "\n" /* feature bit     */ \
> >> +	 "	 .byte 662b-661b\n"		   /* sourcelen       */ \
> >> +	 "	 .byte 664f-663f\n"		   /* replacementlen  */ \ 
> > 
> > ... should do the trick. (also note the extra line after the #define)
> > 
> 
> This formatting seems a bit odd; _ASM_ALIGN, _ASM_PTR, and .section are
> functionally equivalent to the opcode field, as is .byte, so the shift
> in indentation for the .byte lines seems odd at best.
> 

OK, I'll repost with corrected indentation. I tried to follow the
original style as closely as possible, but indeed a cleanup is needed
here.

Mathieu

> 	-hpa
> 
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
