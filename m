Return-Path: <linux-kernel-owner+w=401wt.eu-S1753314AbXIPThh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbXIPThh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 15:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbXIPTha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 15:37:30 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2670 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbXIPTh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 15:37:29 -0400
Date: Sun, 16 Sep 2007 21:36:54 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Matej Laitl <strohel@gmail.com>
cc: Sam Ravnborg <sam@ravnborg.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] menuconfig: distinguish between selected-by-another
 options and comments
In-Reply-To: <200709162024.48124.strohel@gmail.com>
Message-ID: <Pine.LNX.4.64.0709162106280.1817@scrub.home>
References: <200709152004.11930.strohel@gmail.com> <200709161944.31780.strohel@gmail.com>
 <Pine.LNX.4.64.0709161955340.1817@scrub.home> <200709162024.48124.strohel@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 16 Sep 2007, Matej Laitl wrote:

> The v2 was maybe more intuitive, but had at least one flaw, where it claimed
> the option was selected by another, while it was in fact only made
> unchangeable by 'bool "Enable block layer" if EMBEDDED', defaulting to y.

The point is that I'm getting more concerned about overloading the 
interface with nontrivial information.
Another direction to consider would be to add this information to the help 
text, e.g. choose one syntax for nonchangable symbols and then the user 
can press help to find more detailed information.

> > This maximum value is overridden  
> > by the minimum value, so I wouldn't like it to be exported like this.
> 
> Where exactly does this happen?

sym_tristate_within_range() checks whether the new value is ok and 
sym_calc_value() uses rev_dep to override the value when necessary.

> There are cases when maximum < minimum, for
> example when you <M> THINKPAD_ACPI, then <N> BACKLIGHT_LCD_SUPPORT. After that,
> BACKLIGHT_CLASS_DEVICE has minimum of 1 (selected by THINKPAD_ACPI) and maximum
> 0 (depends on BACKLIGHT_LCD_SUPPORT, which is n)

The actual maximum value is then 1.

> The function names are maybe suboptimal, I agree.

The variable name is already correct, it's the visibility value of a 
symbol not its maximum. In the case of the "if EMBEDDED" then individual 
menu entries can still be visible, if any child entry is visible (see 
menu_is_visible()). 

bye, Roman
