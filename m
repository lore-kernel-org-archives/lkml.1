Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721Ab0AIQr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab0AIQr1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 11:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679Ab0AIQr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 11:47:26 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:48099 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620Ab0AIQrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 11:47:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UdzNUfy64u+qrX70YaBq7lAKcOaH3oaJ7eHtL9MrDp+N8s9E+gvT3vKFcjHHh51smk
         CMFzP+Xw393fRcj/80XBP6c/A6cX7SFp5Ox3eKzwiQj99oluktpOBtD6X8rP71jA9bh7
         NE+LfBdsq0SjZAkUVUeHg0XAaUe1gCj2/IGD4=
MIME-Version: 1.0
In-Reply-To: <1262875968-1078-1-git-send-email-mmarek@suse.cz>
References: <1262875968-1078-1-git-send-email-mmarek@suse.cz>
Date: Sat, 9 Jan 2010 18:47:21 +0200
Message-ID: <9b2db90b1001090847n5d294f26re43686722435742f@mail.gmail.com>
Subject: Re: [PATCH 0/2] nconfig
From: Nir Tzachar <nir.tzachar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 7, 2010 at 4:52 PM, Michal Marek <mmarek@suse.cz> wrote:
> Hi Nir,
>
> Just FYI: I queued nconfig for the next merge window. I added a patch to
> mark some functions static and changed the description of your patch,
> otherwise it's the v7 version you posted.

Thats gr8. Thanks.

I would also appreciate if you can add the patch I sent Jan (attached
below). It fixed the problem Jan raised. If you need, I'll make it a
proper patch on top of v7.

Cheers.

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
