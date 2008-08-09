Return-Path: <linux-kernel-owner+w=401wt.eu-S1752897AbYHIRCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbYHIRCh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 13:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbYHIRC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 13:02:26 -0400
Received: from mailin.studentenwerk.mhn.de ([141.84.225.229]:33726 "EHLO
	email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189AbYHIRCZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 13:02:25 -0400
From: Wolfgang Walter <wolfgang.walter@stwm.de>
Organization: Studentenwerk =?iso-8859-1?q?M=FCnchen?=
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Kernel oops with 2.6.26, padlock and ipsec: probably problem with fpu state changes
Date: Sat, 9 Aug 2008 19:02:23 +0200
User-Agent: KMail/1.9.5
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "viro@ZenIV.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "vegard.nossum@gmail.com" <vegard.nossum@gmail.com>
References: <200807171653.59177.wolfgang.walter@stwm.de> <200808091757.32999.wolfgang.walter@stwm.de> <489DC15D.9070308@zytor.com>
In-Reply-To: <489DC15D.9070308@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808091902.23725.wolfgang.walter@stwm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 9. August 2008 18:10 schrieb H. Peter Anvin:
> Wolfgang Walter wrote:
> > How could any kernel code use MMX/SSE/FPU when the interrupt case isn't
> > handled?
>
> I don't think we have ever allowed MMX/SSE/FPU code in interrupt
> handlers.  kernel_fpu_begin()..end() lock out preemption, and so could
> only be interrupted, not preempted.

What about

arch/x86/lib/mmx_32.c

and then

include/asm-x86/string_32.h

couldn't memcpy end as beeing implemented with MMX? And interrupt handlers may 
use memcpy? Or did I miss something?

Similar: couldn't memcpy be called in asynchronous way, say a page fault or 
someting like that?

Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
Leiter EDV
Leopoldstraße 15
80802 München
Tel: +49 89 38196 276
Fax: +49 89 38196 150
Email: wolfgang.walter@stwm.de
http://www.studentenwerk-muenchen.de/
