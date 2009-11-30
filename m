Return-Path: <linux-kernel-owner+w=401wt.eu-S1752784AbZK3Qeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbZK3Qeo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 11:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbZK3Qem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 11:34:42 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:32824 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbZK3Qel convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 11:34:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WIZ/iq4F54G4CfTqcmXrd2+ZRrIQMRFmJW4ePSrfC91Au4LwkR6DieKJixWAe7ePQ8
         rLeVu4xso+/MixMk0U784LhCvspmI5mnPF0RhE8aqWEEKjzZqJwlTf/CFCr9QefcBjzd
         UL2SwWWuBOJ5vec8abVVagoBp4MN7tiZkjAcs=
MIME-Version: 1.0
In-Reply-To: <4B13D951.8090907@suse.cz>
References: <1257602859-32339-1-git-send-email-nir.tzachar@gmail.com>
	 <1259144923-25362-1-git-send-email-nir.tzachar@gmail.com>
	 <4B13D951.8090907@suse.cz>
Date: Mon, 30 Nov 2009 18:34:46 +0200
Message-ID: <9b2db90b0911300834o2883851cxa89b9eff9e5e7fda@mail.gmail.com>
Subject: Re: [PATCH] nconfig v7
From: Nir Tzachar <nir.tzachar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, zippel@linux-m68k.org, andi@firstfloor.org,
       randy.dunlap@oracle.com, elendil@planet.nl, bn@niasdigital.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal

On Mon, Nov 30, 2009 at 4:40 PM, Michal Marek <mmarek@suse.cz> wrote:
> On 25.11.2009 11:28, nir.tzachar@gmail.com wrote:
>> Hello.
>>
>> Attached bellow is version 7 of nconfig, an ncurses based replacement for
>> menuconfig. After a thorough overhaul, addressing all concerns raised in the
>> past by users on these lists, I would be happy if this version is favorably
>> considered for inclusion.
>>
>> Major changes since version 6:
>>
>> 1) un-selectable menu items have 'XXX' before them, to indicate the fact.
>> 2) there are three separate help menus: main help (bound to F1), symbol help
>>    (bound to F2 and 'h') and short instructions (bound to F3).
>
> Hi Nir,
>
> I tried it a few times, it's nice :). I get a few warnings about missing
> prototypes when compiling it:
>  HOSTCC  scripts/kconfig/nconf.gui.o
> scripts/kconfig/nconf.gui.c:23: warning: no previous prototype for
> ‘set_normal_colors’
> scripts/kconfig/nconf.gui.c:68: warning: no previous prototype for
> ‘normal_color_theme’
> scripts/kconfig/nconf.gui.c:100: warning: no previous prototype for
> ‘no_colors_theme’
>  HOSTCC  scripts/kconfig/nconf.o
> scripts/kconfig/nconf.c:455: warning: no previous prototype for
> ‘process_special_keys’
> scripts/kconfig/nconf.c:487: warning: no previous prototype for
> ‘get_next_hot’
> scripts/kconfig/nconf.c:506: warning: no previous prototype for ‘canbhot’
> scripts/kconfig/nconf.c:514: warning: no previous prototype for ‘is_hot’
> scripts/kconfig/nconf.c:522: warning: no previous prototype for ‘make_hot’
> scripts/kconfig/nconf.c:582: warning: no previous prototype for ‘item_make’
> scripts/kconfig/nconf.c:626: warning: no previous prototype for
> ‘item_add_str’
> scripts/kconfig/nconf.c:656: warning: no previous prototype for ‘item_tag’
> scripts/kconfig/nconf.c:668: warning: no previous prototype for
> ‘curses_item_index’
> scripts/kconfig/nconf.c:673: warning: no previous prototype for ‘item_data’
> scripts/kconfig/nconf.c:684: warning: no previous prototype for
> ‘item_is_tag’
> scripts/kconfig/nconf.c:691: warning: no previous prototype for
> ‘set_config_filename’

I'll try to fix these.

> These probably can be static. Oh, and when I suspend the program with
> Ctrl-Z, resume with 'fg' and hit an arrow key, the escape sequence is
> interpreted as a genuine ESC and it either jumps one menu level above or
> wants to exit the program. It happens to me both in xterm and
> gnome-terminal, ncurses version is 5.6. Can you see it as well or is
> there something broken on my side?

I get the same behavior on my system. Try changing the cbreak() in
nconfig.c to raw(), which will disable signal generation for ^Z and
^C.

> Other than that, I found no issues so far (except for the not really
> readable shortcut nOtation, but you say it's hard to fix, so let's
> forget about it for now). I'll use it a bit more and have a look at the
> code. For now, it is in git://repo.or.cz/linux-kbuild.git#for-review as is.

Thanks :)

> Michal
>

Cheers,
Nir.
