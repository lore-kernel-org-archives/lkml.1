Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbZK3OkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbZK3OkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 09:40:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbZK3OkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 09:40:16 -0500
Received: from cantor.suse.de ([195.135.220.2]:48519 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230AbZK3OkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 09:40:14 -0500
Message-ID: <4B13D951.8090907@suse.cz>
Date: Mon, 30 Nov 2009 15:40:17 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-5.3 Thunderbird/3.0b4
MIME-Version: 1.0
To: nir.tzachar@gmail.com
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, zippel@linux-m68k.org, andi@firstfloor.org,
       randy.dunlap@oracle.com, elendil@planet.nl, bn@niasdigital.com
Subject: Re: [PATCH] nconfig v7
References: <1257602859-32339-1-git-send-email-nir.tzachar@gmail.com> <1259144923-25362-1-git-send-email-nir.tzachar@gmail.com>
In-Reply-To: <1259144923-25362-1-git-send-email-nir.tzachar@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.11.2009 11:28, nir.tzachar@gmail.com wrote:
> Hello.
> 
> Attached bellow is version 7 of nconfig, an ncurses based replacement for
> menuconfig. After a thorough overhaul, addressing all concerns raised in the
> past by users on these lists, I would be happy if this version is favorably 
> considered for inclusion. 
> 
> Major changes since version 6:
> 
> 1) un-selectable menu items have 'XXX' before them, to indicate the fact.
> 2) there are three separate help menus: main help (bound to F1), symbol help
>    (bound to F2 and 'h') and short instructions (bound to F3).

Hi Nir,

I tried it a few times, it's nice :). I get a few warnings about missing
prototypes when compiling it:
  HOSTCC  scripts/kconfig/nconf.gui.o
scripts/kconfig/nconf.gui.c:23: warning: no previous prototype for
‘set_normal_colors’
scripts/kconfig/nconf.gui.c:68: warning: no previous prototype for
‘normal_color_theme’
scripts/kconfig/nconf.gui.c:100: warning: no previous prototype for
‘no_colors_theme’
  HOSTCC  scripts/kconfig/nconf.o
scripts/kconfig/nconf.c:455: warning: no previous prototype for
‘process_special_keys’
scripts/kconfig/nconf.c:487: warning: no previous prototype for
‘get_next_hot’
scripts/kconfig/nconf.c:506: warning: no previous prototype for ‘canbhot’
scripts/kconfig/nconf.c:514: warning: no previous prototype for ‘is_hot’
scripts/kconfig/nconf.c:522: warning: no previous prototype for ‘make_hot’
scripts/kconfig/nconf.c:582: warning: no previous prototype for ‘item_make’
scripts/kconfig/nconf.c:626: warning: no previous prototype for
‘item_add_str’
scripts/kconfig/nconf.c:656: warning: no previous prototype for ‘item_tag’
scripts/kconfig/nconf.c:668: warning: no previous prototype for
‘curses_item_index’
scripts/kconfig/nconf.c:673: warning: no previous prototype for ‘item_data’
scripts/kconfig/nconf.c:684: warning: no previous prototype for
‘item_is_tag’
scripts/kconfig/nconf.c:691: warning: no previous prototype for
‘set_config_filename’

These probably can be static. Oh, and when I suspend the program with
Ctrl-Z, resume with 'fg' and hit an arrow key, the escape sequence is
interpreted as a genuine ESC and it either jumps one menu level above or
wants to exit the program. It happens to me both in xterm and
gnome-terminal, ncurses version is 5.6. Can you see it as well or is
there something broken on my side?

Other than that, I found no issues so far (except for the not really
readable shortcut nOtation, but you say it's hard to fix, so let's
forget about it for now). I'll use it a bit more and have a look at the
code. For now, it is in git://repo.or.cz/linux-kbuild.git#for-review as is.

Michal
