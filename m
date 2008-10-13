Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbYJMHkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbYJMHkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 03:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbYJMHk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 03:40:28 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45699 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbYJMHk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 03:40:27 -0400
Date: Mon, 13 Oct 2008 03:40:25 -0400 (EDT)
From: Jan Engelhardt <jengelh@medozas.de>
To: "Alexander V. Lukyanov" <lav@netis.ru>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Ncurses Developers <ncurses-dev@gnu.org>
Subject: Re: linux 2.6.26 vt back_color_erase
In-Reply-To: <20081013052437.GA27761@night.netis.ru>
Message-ID: <alpine.LNX.1.10.0810130317450.9172@fbirervta.pbzchgretzou.qr>
References: <20081003081147.GA16414@night.netis.ru> <20081010164953.GA27092@night.netis.ru> <alpine.LNX.1.10.0810101310400.21097@fbirervta.pbzchgretzou.qr> <20081013052437.GA27761@night.netis.ru>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2008-10-13 01:24, Alexander V. Lukyanov wrote:

>On Fri, Oct 10, 2008 at 01:22:08PM -0400, Jan Engelhardt wrote:
>> >> Current linux kernel has broken bce semantics. Now insert_line and
>> >> delete_line clear the new lines with default color and not with the
>> >> current background as they should, and what is expected by ncurses.
>> 
>> I beg to differ. The Linux VT now does exactly what an xterm does,
>
>I have just tested again: my xterm does erase new lines with current color,
>just as linux console before the change. My xterm version: XTerm(196).
>Please test yours and check the version.

It seems that xterm-235 does indeed erase-with-current on _scrolling_
(i.e. PS1='$'; echo -en "\e[25B\e[44mfoo\n\e[0m") as do urxvt.

>Probably color ls -l is just broken and should be fixed. Why was it
>necessary to change the console color semantics that was there for years?

Because the Linux VT also did erase-with-current on _linewrap_,
which xterm and urxvt certainly do not do.

Mh, this is really unfortunate; I agree something
needs to be backed out.

