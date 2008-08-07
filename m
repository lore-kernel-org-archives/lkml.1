Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082AbYHGMVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbYHGMVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750777AbYHGMU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:20:57 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:57810 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750734AbYHGMUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:20:55 -0400
Date: Thu, 7 Aug 2008 10:54:36 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Amol Lad <amol.lad@gmail.com>
cc: linux-embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: kernel command line from u-boot
In-Reply-To: <8c675e9b0808062141s74f1a7bfob5cab6b23b0268d3@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0808071050280.9798@vixen.sonytel.be>
References: <8c675e9b0808062141s74f1a7bfob5cab6b23b0268d3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-272805442-1218099039=:9798"
Content-ID: <Pine.LNX.4.64.0808071050420.9798@vixen.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-272805442-1218099039=:9798
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0808071050421.9798@vixen.sonytel.be>

On Thu, 7 Aug 2008, Amol Lad wrote:
> It seems that there is a small problem when kernel parses the command
> line passed by u-boot.

It doesn't seem to be specific to u-boot...

> For example, when I add "board=myboard boardid=1" in the command line
> and register handler in kernel as __setup("board", board_setup), then
> the board_setup function is called twice : once with argument
> "myboard" and second time with argument "d=1". So kernel is calling
                                           ^^^
Wow, when init/main.c:obsolete_checksetup() matches the `board' part,
it ignores the next character (`i'), assuming this is `=', and passes
the remainder (`d=1').

> handler registered for param "board" for "boardid" also. Is this ok ?

I don't think this is OK.

Probably nobody noticed as this part of the code takes care of the
`obsolete-style' parameters. `module_param' is the new way.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis 293-0376800-10 GEBA-BE-BB
---584349381-272805442-1218099039=:9798--
