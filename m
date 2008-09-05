Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbYIEUDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbYIEUDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 16:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbYIEUDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 16:03:06 -0400
Received: from 1wt.eu ([62.212.114.60]:3203 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbYIEUDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 16:03:05 -0400
Date: Fri, 5 Sep 2008 21:59:30 +0200
From: Willy Tarreau <w@1wt.eu>
To: Nir Tzachar <tzachar@grad120a.cs.bgu.ac.il>
Cc: linux-kernel@vger.kernel.org, bzolnier@gmail.com, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, ariveira@gmail.com, rdunlap@xenotime.net,
       kosaki.motohiro@jp.fujitsu.com, 7eggert@gmx.de,
       Nir Tzachar <nir@tzachar.com>
Subject: Re: [PATCH] ncurses based config V2
Message-ID: <20080905195930.GA27913@1wt.eu>
References: <1220469076-16487-1-git-send-email-nir@tzachar.com> <1220603220-17090-1-git-send-email-nir@tzachar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220603220-17090-1-git-send-email-nir@tzachar.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 05, 2008 at 11:27:00AM +0300, Nir Tzachar wrote:
> Changes:
> 1) Fixed segfaults in help window.
> 2) Removed the instructions window, made the instructions appear as a button
>    which displays a popup window.
> 3) Added hot keys support. As ncurses does not support several colors inside
>    a menu, keys are highlighted using "()".
> 4) Optimized for 80x24 terminals.
> 6) Fixed zconf.y to use _menu_init
> 7) added nconfig to "make help"
> 8) Misc fixes.
> 
> Comments are appreciated.

OK, I've just tried it. Here are the first comments I can make :

  - colors are too dark. Cyan on black is barely readable, red on black is
    almost unreadable and blue on black is not readable at all, I have to
    switch off the light to read it. Most often you'll see light shades of
    grey (even white) in interfaces because it's hard to see dark shades,
    and bright flashy letters would dazzle and be seen as fuzzy. Many colors
    are perfectly readable on while or even light grey (except yellow and
    sometimes cyan). Blue backgrounds were often used under DOS and were
    OK with almost all colors except red (well-known eye focus problem).
    But there was a trick, pixels were very large in 640x200, nowaydays
    we have small pixels and letters are not much readable anymore on blue
    backgrounds. For your tests, you can try to load 
    xterm -bg <color> -fg <color> and ensure that you're using a medium
    font (tickness of 1-pixel).

  - pressing arrows too fast regularly escapes (probably because of the
    ESC prefix, I don't know). This is rather strange, because no other
    application does this to me. Is there a specific initialization
    sequence with ncurses to state that arrows should return special codes
    instead of the ESC prefix ? (I have no idea)

  - entering text in boxes (eg: local version) does not move the cursor,
    it remains at the beginning of the line. If I press any arrow, the
    box immediately closes (most likely the Esc prefix again).

  - in the input boxes, spaces are missing aroung the title, which touches
    the frame (eg: Local version again).

  - in "instructions", it's not explained how to leave that box. I found
    both Enter and Esc to work, but a last line with a small message would
    be better.

  - I noticed I was tempted a lot to press "?" to get help, but the key is
    not bound. It would be nice to have it bound to Help since make oldconfig
    and menuconfig to both report help that way.

  - I'm not convinced that the parenthesis around hotkeys make the menu
    that much readable, especially when there are lots of short words or
    even acronyms. Eg :
        [ ]   (U)TS namespace
        [ ]   (I)PC namespace
        [ ]   (U)ser namespace (EXPERIMENTAL)
        [ ]   (P)ID Namespaces (EXPERIMENTAL)

    I don't know if there is something such as a bold attribute in ncurses,
    it would make sense to use it IMHO because you don't force a color on
    people's terms, you rely on the style which works well for them.

I'm sorry I don't go further for now, the arrows causing frequent exits is
too bothersome, I've started it about 30 times just for this report, it's
too hard to navigate. I hope that the points above are already helpful.

Regards,
Willy

