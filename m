Return-Path: <linux-kernel-owner+w=401wt.eu-S1762108AbYJJRWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762108AbYJJRWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 13:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756034AbYJJRWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 13:22:11 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50957 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbYJJRWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 13:22:10 -0400
Date: Fri, 10 Oct 2008 13:22:08 -0400 (EDT)
From: Jan Engelhardt <jengelh@medozas.de>
To: "Alexander V. Lukyanov" <lav@netis.ru>
cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Ncurses Developers <ncurses-dev@gnu.org>
Subject: Re: linux 2.6.26 vt back_color_erase
In-Reply-To: <20081010164953.GA27092@night.netis.ru>
Message-ID: <alpine.LNX.1.10.0810101310400.21097@fbirervta.pbzchgretzou.qr>
References: <20081003081147.GA16414@night.netis.ru> <20081010164953.GA27092@night.netis.ru>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-10-10 12:49, Alexander V. Lukyanov wrote:

>On Fri, Oct 03, 2008 at 12:11:47PM +0400, Alexander V. Lukyanov wrote:
>> vc->vc_scrl_erase_char was introduced in 2.6.26 for some reason. I beleave
>> this change should be backed out.

There is video_erase_char which contains the background fill and is used
for escape codes such as \e[J and \e[K; scrolling also traditionally used
these, which I consider a visual bug. So scrl_erase_char was introduced
that contains the default color, and which is used for scrolling
(the complement of erase ops like J and K).

>I think that the test cases Jan provided could be fixed by temporary
>changing erase char when doing cr/lf when vc->vc_need_wrap is true.
>There is no need to change erase character for all scrolling operations.

Only in the latter of the following two,
	\e[44mfoo\n\e[42mbar
and
	\e[44moverlylonglinemorethan80charsorso\e[42mbar
vc_need_wrap will be set to 1 during the course of printing it to
the console, but the background fill issue happens with both
test strings.

>> Current linux kernel has broken bce semantics. Now insert_line and
>> delete_line clear the new lines with default color and not with the
>> current background as they should, and what is expected by ncurses.

I beg to differ. The Linux VT now does exactly what an xterm does,
namely that newly inserted lines do not get filled with the
background color. And I consider that the right thing, because it
does not leave ugly color patches lying on your screen when `ls -l`
overruns the screen width, and someone decided to use a background
color for his filenames.

ncurses should not expect anything. Except what is in terminfo.
Do we need a terminfo db update for the "linux" term?
