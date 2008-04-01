Return-Path: <linux-kernel-owner+w=401wt.eu-S1760135AbYDAUJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135AbYDAUJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 16:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757120AbYDAUJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 16:09:34 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:43770
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756948AbYDAUJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 16:09:34 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-tiny@selenic.com
Subject: Re: [PATCH] Configure out DMI scanning code v2 (Linux Tiny)
Date: Tue, 1 Apr 2008 15:09:28 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       Reynes Philippe <tremyfr@yahoo.fr>, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
References: <20080212100418.5de764da@crazy> <20080401120036.2254d7eb.akpm@linux-foundation.org>
In-Reply-To: <20080401120036.2254d7eb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804011509.28842.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 April 2008 14:00:36 Andrew Morton wrote:
>    text    data     bss     dec     hex filename
> 1614279  210524  159992 1984795  1e491b vmlinux
>
> but when I remove the ifdefs around the tables and rely on the compiler
> removing the code and data I get
>
>    text    data     bss     dec     hex filename
> 1614447  210972  159992 1985411  1e4b83 vmlinux
>
> An additional 616 bytes of useless stuff.
>
> Ingo, I think there was some trick to making this work right.  Do you
> recall?

Does bloat-o-meter say what the additional 616 bytes _is_?

scripts/bloat-o-meter vmlinux.old vmlinux.new

P.S.  What busybox did:

    ifneq ($(strip $(CONFIG_DEBUG)),y)
        OPTIMIZATION+=$(call check_cc,
$(CC),-ffunction-sections -fdata-sections,)
        CHECKED_LDFLAGS += $(call check_ld,$(LD),--gc-sections,)
    endif

Tells gcc to put each function and each global into its own ELF section, and 
then told the linker to garbage collect unused sections...

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
