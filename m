Return-Path: <linux-kernel-owner+w=401wt.eu-S1761492AbZEMTnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761492AbZEMTnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 15:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759259AbZEMTmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 15:42:53 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:46160 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757795AbZEMTmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 15:42:52 -0400
X-Auth-Info: MSj/VTPFxunhsPKY18oCSyjGPcVEnLe8Er6SjvoQNNw=
To: Li Yang <leoli@freescale.com>
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Scott Wood <scottwood@freescale.com>,
       Kumar Gala <galak@kernel.crashing.org>
From: Wolfgang Denk <wd@denx.de>
Subject: Re: [PATCH] [PowerPC] MPC8272ADS: fix device tree for 8 MB flash size
Mime-version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
In-reply-to: <2a27d3730905130328m27743852w2d68a62ebc32ce31@mail.gmail.com>
References: <1242155174-2513-1-git-send-email-wd@denx.de> <2a27d3730905130328m27743852w2d68a62ebc32ce31@mail.gmail.com>
Comments: In-reply-to Li Yang <leoli@freescale.com>
   message dated "Wed, 13 May 2009 18:28:09 +0800."
Date: Wed, 13 May 2009 21:42:49 +0200
Message-Id: <20090513194249.BA7D9832E416@gemini.denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Li Yang,

In message <2a27d3730905130328m27743852w2d68a62ebc32ce31@mail.gmail.com> you wrote:
>
> Although 8MB seems to be the common size used.  It can be very easy
> changed as a pluggable module.  It might be better to make the code
> working for any reasonable flash sizes.

You either have to provide a correct device tree for your board, or
use a boot loader / boot wrapper that fixes the flash base address and
size.

At the moment, U-Boot does not  contain  any  code  yet  to  do  that
(patches  welcome :-), and as far as I understand the cuImage wrapper
works just the other way  round:  it  adjusts  the  mappings  to  the
settings  in  the  device tree, which may or may not match the actual
hardware. This may work, but at least gives  you  a  different  flash
memory  map  in Linux than what you had before in U-Boot, so it's not
really nice either.


Hm... it seems the majority of MPC8272ADS boards seems to come indeed
with 8 MB NOR flash, so I wonder if the patch should actually go in?

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
In accord with UNIX philosophy, Perl gives you enough  rope  to  hang
yourself.              - L. Wall & R. L. Schwartz, _Programming Perl_
