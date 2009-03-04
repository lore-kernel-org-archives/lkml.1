Return-Path: <linux-kernel-owner+w=401wt.eu-S1755048AbZCDRRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbZCDRRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 12:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbZCDRRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 12:17:40 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:37559 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbZCDRRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 12:17:39 -0500
Message-ID: <49AEB7F8.2000206@oracle.com>
Date: Wed, 04 Mar 2009 09:18:48 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Cheng Renquan <crquan@gmail.com>
CC: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] [KBUILD] configuration system improvements
References: <1235401804-8136-1-git-send-email-crquan@gmail.com>	 <49AB55B9.3050301@oracle.com>	 <91b13c310903022009l363497bbi380356c19caa53b3@mail.gmail.com>	 <49AD75D4.20600@oracle.com> <49AD8B2F.4060700@oracle.com> <91b13c310903032250n77c754f4qdcc8be9caf9e9cd5@mail.gmail.com>
In-Reply-To: <91b13c310903032250n77c754f4qdcc8be9caf9e9cd5@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.49AEB79C.0022:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cheng Renquan wrote:

[snip]


> Maybe you can try to "make gconfig" from a vanilla
> linux-2.6.29-rc6-git5 kernel, without these kbuild patches, to check
> if your system can configure kernel with gconfig?

I had already reported that gconfig without this patch series works fine.

> Alternatively, you can use this to compile gconfig,
> 
> gcc -Wall -Wl,--as-needed -Wstrict-prototypes -O2 -fomit-frame-pointer
> -D LKC_DIRECT_LINK `pkg-config --cflags gtk+-2.0 gmodule-2.0
> libglade-2.0` -o scripts/kconfig/gconf scripts/kconfig/gconf.c
> scripts/kconfig/kconfig_load.c scripts/kconfig/zconf.tab.c -lncurses
> `pkg-config --libs gtk+-2.0 gmodule-2.0 libglade-2.0`

OK, did that.

> this will build a smaller scripts/kconfig/gconf, with less library
> dependencies, or try "-O2" to "-O0", "-ggdb" to compute more debuging
> information, thanks,

With -O0 -ggdb, this is the backtrace:

(gdb) bt
#0  0x000000000041a6ab in get_symbol_str (r=0x7fff41724130, sym=0x0)
    at scripts/kconfig/menu.c:497
#1  0x000000000041a87c in menu_get_ext_help (menu=0xd82370, 
    help=0x7fff41724130) at scripts/kconfig/menu.c:531
#2  0x0000000000408dc3 in text_insert_help (menu=0xd82370)
    at scripts/kconfig/gconf.c:461
#3  0x000000000040a5f4 in on_treeview2_cursor_changed (treeview=0x6d03b0, 
    user_data=0x0) at scripts/kconfig/gconf.c:1102
#4  0x00002aef6a22dd2f in g_closure_invoke ()
   from /usr/lib64/libgobject-2.0.so.0
#5  0x00002aef6a2401fd in ?? () from /usr/lib64/libgobject-2.0.so.0
#6  0x00002aef6a241c55 in g_signal_emit_valist ()
   from /usr/lib64/libgobject-2.0.so.0
#7  0x00002aef6a242043 in g_signal_emit () from /usr/lib64/libgobject-2.0.so.0
#8  0x00002aef699f3ada in ?? () from /usr/lib64/libgtk-x11-2.0.so.0
#9  0x00002aef699fa5de in ?? () from /usr/lib64/libgtk-x11-2.0.so.0
#10 0x00002aef69905bbf in ?? () from /usr/lib64/libgtk-x11-2.0.so.0
#11 0x00002aef6a22dd2f in g_closure_invoke ()
   from /usr/lib64/libgobject-2.0.so.0
#12 0x00002aef6a2405f6 in ?? () from /usr/lib64/libgobject-2.0.so.0
#13 0x00002aef6a241989 in g_signal_emit_valist ()
   from /usr/lib64/libgobject-2.0.so.0
#14 0x00002aef6a242043 in g_signal_emit () from /usr/lib64/libgobject-2.0.so.0
#15 0x00002aef69a0cff5 in ?? () from /usr/lib64/libgtk-x11-2.0.so.0
#16 0x00002aef698feef2 in gtk_propagate_event ()
   from /usr/lib64/libgtk-x11-2.0.so.0
#17 0x00002aef698ffe95 in gtk_main_do_event ()
   from /usr/lib64/libgtk-x11-2.0.so.0
#18 0x00002aef69db87bc in ?? () from /usr/lib64/libgdk-x11-2.0.so.0
#19 0x00002aef6a69a064 in g_main_context_dispatch ()
   from /usr/lib64/libglib-2.0.so.0
#20 0x00002aef6a69d35d in ?? () from /usr/lib64/libglib-2.0.so.0
#21 0x00002aef6a69d657 in g_main_loop_run () from /usr/lib64/libglib-2.0.so.0
#22 0x00002aef69900263 in gtk_main () from /usr/lib64/libgtk-x11-2.0.so.0
#23 0x000000000040b846 in main (ac=2, av=0x7fff41725408)
    at scripts/kconfig/gconf.c:1609

-- 
~Randy
