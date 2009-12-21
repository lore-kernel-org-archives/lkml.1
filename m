Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbZLUWqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbZLUWqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 17:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbZLUWqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 17:46:35 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:53689
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbZLUWqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 17:46:35 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: Why is ARCH m68k hardwired into drivers/net/wan/Makefile?
Date: Mon, 21 Dec 2009 16:46:31 -0600
User-Agent: KMail/1.11.2 (Linux/2.6.28-16-generic; KDE/4.2.2; x86_64; ; )
Cc: kernel list <linux-kernel@vger.kernel.org>
References: <200912202342.16806.rob@landley.net> <10f740e80912210157y7b506677q6a40b40435b4634f@mail.gmail.com>
In-Reply-To: <10f740e80912210157y7b506677q6a40b40435b4634f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912211646.32326.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 December 2009 03:57:49 Geert Uytterhoeven wrote:
> On Mon, Dec 21, 2009 at 06:42, Rob Landley <rob@landley.net> wrote:
> > Anyone have an opinion on this?
> >
> > From drivers/net/wan/Makefile:
>
> You cut one important line here:
> | ifeq ($(CONFIG_WANXL_BUILD_FIRMWARE),y)
> |
> >>ifeq ($(ARCH),m68k)
> >>  AS68K = $(AS)
> >>  LD68K = $(LD)
> >>else
> >>  AS68K = as68k
> >>  LD68K = ld68k
> >>endif
>
> The corresponding Kconfig entry reads:
>
> config WANXL_BUILD_FIRMWARE
>         bool "rebuild wanXL firmware"
>         depends on WANXL && !PREVENT_FIRMWARE_BUILD
>         help
>           Allows you to rebuild firmware run by the QUICC processor.
>           It requires as68k, ld68k and hexdump programs.
>
>           You should never need this option, say N.
>
> Gr{oetje,eeting}s,

Ah, the card has an onboard m68k processor, separate from the host CPU.

Rob
-- 
Latency is more important than throughput. It's that simple. - Linus Torvalds
