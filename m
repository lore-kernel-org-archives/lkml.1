Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbZLNNqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbZLNNqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 08:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbZLNNp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 08:45:59 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:53529 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733AbZLNNp6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 08:45:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VFkVjOBZWYO1oJQsoJ3xgJywVKKSvpIzxu5rG7vOLwndm56EIW9dA7Q4TZGLOBpCYA
         g9UeS20atBzdViDMJ48/TkEjo/NmXMbvn5Jbw15jnbMCsSBdMJ0+pBnNPwhqUq+I96jo
         k/UujAZGPg3Aa/yDCgqHjIt3qyYbyHCs6oXEY=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.01.0912141325220.21244@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.0912112023170.32039@obet.zrqbmnf.qr>
	 <9b2db90b0912122323w25d2d815o70d0bd2f1e19a228@mail.gmail.com>
	 <alpine.LSU.2.01.0912131118280.28039@obet.zrqbmnf.qr>
	 <9b2db90b0912132141j6b06d26dgd1e14acf3631de13@mail.gmail.com>
	 <alpine.LSU.2.01.0912141325220.21244@obet.zrqbmnf.qr>
Date: Mon, 14 Dec 2009 15:45:56 +0200
Message-ID: <9b2db90b0912140545i158cc4b5o9cd72feca9e8983f@mail.gmail.com>
Subject: Re: nconfig v7
From: Nir Tzachar <nir.tzachar@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please try this patch. It should solve both of the problems you reported.

diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index 8c56150..cab6bb0 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -984,7 +984,7 @@ static void build_conf(struct menu *menu)
                                break;
                        default:
                                tmp = 2 + strlen(sym_get_string_value(sym));
-                               item_make(menu, 's', "(%s)",
+                               item_make(menu, 's', "    (%s)",
                                                sym_get_string_value(sym));
                                tmp = indent - tmp + 4;
                                if (tmp < 0)
@@ -1072,8 +1072,8 @@ static void show_menu(const char *prompt, const
char *instructions,

        /* position the menu at the middle of the screen */
        scale_menu(curses_menu, &maxy, &maxx);
-       maxx = min(maxx, mwin_max_cols);
-       maxy = mwin_max_lines-1;
+       maxx = min(maxx, mwin_max_cols-2);
+       maxy = mwin_max_lines-2;
        menu_window = derwin(main_window,
                        maxy,
                        maxx,


On Mon, Dec 14, 2009 at 2:26 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
> On Monday 2009-12-14 06:41, Nir Tzachar wrote:
>
>>>>> - I get a visual glitch (see Exhibit A below) in General setup (patch
>>>>>  slapped onto 2.6.32); the left frame part is missing.
>>>>
>>>>I cannot reproduce this. Can you provide some more details? (e.g.,
>>>>which terminal, $LINES, $COLUMNS, $TERM)
>>>
>>> xterm -bg black -fg gray -geometry 80x25
>>
>>I cannot reproduce this on any of my systems. Any idea how to
>>proceed?? Can you also send a snapshot?
>>
>
> Add this to the top of arch/x86/Kconfig:
>
> config VERY_LONG_CONFIGURATION_OPTION
>   bool "With a very long long description, you see where this is going"
>
> to reproduce the effect on ARCH=x86.
>
