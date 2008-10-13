Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbYJMFZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbYJMFZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 01:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbYJMFZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 01:25:09 -0400
Received: from star.netis.ru ([213.187.127.146]:50634 "EHLO star.netis.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbYJMFZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 01:25:08 -0400
Date: Mon, 13 Oct 2008 09:24:38 +0400
From: "Alexander V. Lukyanov" <lav@netis.ru>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Ncurses Developers <ncurses-dev@gnu.org>
Subject: Re: linux 2.6.26 vt back_color_erase
Message-ID: <20081013052437.GA27761@night.netis.ru>
References: <20081003081147.GA16414@night.netis.ru> <20081010164953.GA27092@night.netis.ru> <alpine.LNX.1.10.0810101310400.21097@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0810101310400.21097@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.11
X-NETIS-MailScanner-Information: Please contact NETIS Telecom for more information <info@netis.ru> (+7 4852 797797)
X-NETIS-MailScanner-ID: m9D5OMDj013103
X-NETIS-MailScanner: Found to be clean
X-NETIS-MailScanner-SpamCheck: not spam, SpamAssassin (not cached, score=0,
	required 6, autolearn=disabled)
X-NETIS-MailScanner-From: lav@netis.ru
X-NETIS-MailScanner-To: jengelh@medozas.de, linux-kernel@vger.kernel.org,
	ncurses-dev@gnu.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 01:22:08PM -0400, Jan Engelhardt wrote:
> >> Current linux kernel has broken bce semantics. Now insert_line and
> >> delete_line clear the new lines with default color and not with the
> >> current background as they should, and what is expected by ncurses.
> 
> I beg to differ. The Linux VT now does exactly what an xterm does,

I have just tested again: my xterm does erase new lines with current color,
just as linux console before the change. My xterm version: XTerm(196).
Please test yours and check the version. Also, please test other terminals
with bce terminfo attribute. I have tested putty and it also erases new
lines with default colors. And gnome-terminal too.

> namely that newly inserted lines do not get filled with the
> background color. And I consider that the right thing, because it
> does not leave ugly color patches lying on your screen when `ls -l`
> overruns the screen width, and someone decided to use a background
> color for his filenames.

Probably color ls -l is just broken and should be fixed. Why was it
necessary to change the console color semantics that was there for years?

> ncurses should not expect anything. Except what is in terminfo.
> Do we need a terminfo db update for the "linux" term?

Sure, unless the change is reverted. The bce attribute will need to be
disabled, which is a pity as it saves traffic for color full screen
applications. And changing terminfo is very inconvenient for remote logins.

-- 
   Alexander.
