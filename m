Return-Path: <linux-kernel-owner+w=401wt.eu-S1759852AbXI1IeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759852AbXI1IeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 04:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756012AbXI1Idy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 04:33:54 -0400
Received: from bender.weihenstephan.org ([62.245.246.226]:41004 "EHLO
	bender.weihenstephan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508AbXI1Idx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 04:33:53 -0400
From: Juergen Beisert <juergen127@kreuzholzen.de>
Organization: Privat
To: linux-kernel@vger.kernel.org
Subject: *SPAM* Re: kernel 2.6.23-rc6 hangs on Geode GX1
Date: Fri, 28 Sep 2007 10:33:48 +0200
User-Agent: KMail/1.9.4
References: <00ab01c80114$e659d600$7502a8c0@snaponglobal.com> <200709271813.26103.juergen127@kreuzholzen.de>
In-Reply-To: <200709271813.26103.juergen127@kreuzholzen.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709281033.48488.juergen127@kreuzholzen.de>
X-CTCH-RefID: str=0001.0A0B0205.46FCBC6F.00F3,ss=3,fgs=4
X-cff-SpamScore: 5(++++)
X-cff-SpamReport: ----- ----- Spam message from sources that are not
  confirmed spammers.
X-cff-LastScanner: pcre
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 September 2007 18:13, Juergen Beisert wrote:
> Index: linux-2.6.22/arch/i386/kernel/cpu/cyrix.c
> ===================================================================
> --- linux-2.6.22.orig/arch/i386/kernel/cpu/cyrix.c
> +++ linux-2.6.22/arch/i386/kernel/cpu/cyrix.c
> @@ -169,7 +169,7 @@ static void __cpuinit set_cx86_inc(void)
>  	setCx86(CX86_PCR1, getCx86(CX86_PCR1) | 0x02);
>  	/* PCR0 -- Performance Control */
>  	/* Incrementor Margin 10 */
> -	setCx86(CX86_PCR0, getCx86(CX86_PCR0) | 0x04);
> +	setCx86(CX86_PCR0, getCx86(CX86_PCR0) | 0x05);	/* 300MHz CPU */
>  	setCx86(CX86_CCR3, ccr3);	/* disable MAPEN */
>  }
>
> This should be done at runtime in relation to the real CPU clock.

Has someone an idea how I can read back CPUs clock while I'm in 
arch/i386/kernel/cpu/cyrix.c:set_cx86_inc() ? This incrementer setting must 
be done in relation to processor's clock. We could remove this tweaking as 
Marco suggested, or we must fix it to use the correct value.

Juergen
