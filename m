Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbZCDGuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbZCDGuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 01:50:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbZCDGu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 01:50:26 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:53217 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbZCDGuY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 01:50:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=h1daYjgj4vKY+4npzmOXTTURghteNPlQXZ6E/v/C8DHi8OqTzc8q5KC3K3HTC3lXTD
         FrnQMPT97vEDK2IxKxfSc4L5B5bkxCfhcR4r/Q2xoYTBcx2wmLcf+3gw9C1DmyWhp/mp
         zGCC6p7HJ7Z9c4jH6OgDC11FvA9vXHUSwbkZY=
MIME-Version: 1.0
In-Reply-To: <49AD8B2F.4060700@oracle.com>
References: <1235401804-8136-1-git-send-email-crquan@gmail.com>
	 <49AB55B9.3050301@oracle.com>
	 <91b13c310903022009l363497bbi380356c19caa53b3@mail.gmail.com>
	 <49AD75D4.20600@oracle.com> <49AD8B2F.4060700@oracle.com>
Date: Wed, 4 Mar 2009 14:50:21 +0800
Message-ID: <91b13c310903032250n77c754f4qdcc8be9caf9e9cd5@mail.gmail.com>
Subject: Re: [PATCH 0/6] [KBUILD] configuration system improvements
From: Cheng Renquan <crquan@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 4, 2009 at 3:55 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> This is on OpenSUSE 10.3 on x86_64.
>>
>> glibc-2.6.1-18
>> gtk2-2.12.0-5
>>
>> I don't know that I have any other gtk+ programs.
>>
>>> I have developed these patches on default Fedora 10 i686, it runs
>>> well, and today I have tested it under a latest Gentoo x86_64 desktop,
>>> all seems run well here.
>>
>> Here's a backtrace from gdb.  gconfig was built without -d, however.

Your glibc and gtk version not old, the building environment seems
good, but here I don't have a OpenSUSE 10.3 x86_64, really no idea on
how to resolve that problem, maybe I have chance to install a OpenSUSE
10.3 x86_64 these days, the I will try that,

Today I tested these patches on another pristine debian-5.0 (lenny)
x86_64 system, it also performed well.
On systems I tested (glibc 2.6,2.7,2.8, gtk-2.12 or gtk-2.14), it may
report warnings from gtkitemfactory.h and ununsed variables from
images.c, but doesn't matter, after "scripts/kconfig/gconf
arch/x86/Kconfig" run, the gtk gconfig window will display, with
symbol's value quoted well,

/usr/include/gtk-2.0/gtk/gtkitemfactory.h:47: warning: function
declaration isn’t a prototype

root@uitnode1 ~/src/linux-trees/linux-2.6.29-rc6-305-g2450cf5 # make gconfig
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/gconf.o
scripts/kconfig/images.c:6: warning: ‘xpm_load’ defined but not used
scripts/kconfig/images.c:36: warning: ‘xpm_save’ defined but not used
scripts/kconfig/images.c:66: warning: ‘xpm_back’ defined but not used
scripts/kconfig/images.c:175: warning: ‘xpm_symbol_no’ defined but not used
scripts/kconfig/images.c:192: warning: ‘xpm_symbol_mod’ defined but not used
scripts/kconfig/images.c:209: warning: ‘xpm_symbol_yes’ defined but not used
scripts/kconfig/images.c:226: warning: ‘xpm_choice_no’ defined but not used
scripts/kconfig/images.c:243: warning: ‘xpm_choice_yes’ defined but not used
scripts/kconfig/images.c:277: warning: ‘xpm_menu_inv’ defined but not used
scripts/kconfig/images.c:294: warning: ‘xpm_menuback’ defined but not used
scripts/kconfig/gconf.c:946: warning: ‘renderer_toggled’ defined but not used
  HOSTCC  scripts/kconfig/kconfig_load.o
  HOSTCC  scripts/kconfig/kxgettext.o
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/gconf
scripts/kconfig/gconf arch/x86/Kconfig

The get_symbol_str function is totally moved from mconf.c, and kept
intact, to make it available not only used by menuconfig, but also can
be used by gconfig & xconfig & config,

Maybe you can try to "make gconfig" from a vanilla
linux-2.6.29-rc6-git5 kernel, without these kbuild patches, to check
if your system can configure kernel with gconfig?

Alternatively, you can use this to compile gconfig,

gcc -Wall -Wl,--as-needed -Wstrict-prototypes -O2 -fomit-frame-pointer
-D LKC_DIRECT_LINK `pkg-config --cflags gtk+-2.0 gmodule-2.0
libglade-2.0` -o scripts/kconfig/gconf scripts/kconfig/gconf.c
scripts/kconfig/kconfig_load.c scripts/kconfig/zconf.tab.c -lncurses
`pkg-config --libs gtk+-2.0 gmodule-2.0 libglade-2.0`

this will build a smaller scripts/kconfig/gconf, with less library
dependencies, or try "-O2" to "-O0", "-ggdb" to compute more debuging
information, thanks,

In the same time I found the scripts/kconfig/gconf building command
have superfluous paramters, such as "-lncurses", gconfig doesn't need
ncurses, I will post patches to reduce that later.

>
> Here's a better backtrace; gconfig was built with -g (not -d ??!?).
>
> Program received signal SIGSEGV, Segmentation fault.
> 0x00000000004111b6 in get_symbol_str ()
> (gdb) #0  0x00000000004111b6 in get_symbol_str ()
> #1  0x0000000000408acb in on_treeview2_cursor_changed (
>    treeview=<value optimized out>, user_data=<value optimized out>)
>    at /local/linsrc/tmp/linux-2.6.29-rc6-git5/scripts/kconfig/gconf.c:461
> #2  0x00002b61af79bd2f in g_closure_invoke ()
>   from /usr/lib64/libgobject-2.0.so.0
> #3  0x00002b61af7ae1fd in ?? () from /usr/lib64/libgobject-2.0.so.0
> #4  0x00002b61af7afc55 in g_signal_emit_valist ()
>   from /usr/lib64/libgobject-2.0.so.0
> #5  0x00002b61af7b0043 in g_signal_emit () from /usr/lib64/libgobject-2.0.so.0
> #6  0x00002b61ae31bada in ?? () from /usr/lib64/libgtk-x11-2.0.so.0
> #7  0x00002b61ae3225de in ?? () from /usr/lib64/libgtk-x11-2.0.so.0
> #8  0x00002b61ae22dbbf in ?? () from /usr/lib64/libgtk-x11-2.0.so.0
> #9  0x00002b61af79bd2f in g_closure_invoke ()
>   from /usr/lib64/libgobject-2.0.so.0
> #10 0x00002b61af7ae5f6 in ?? () from /usr/lib64/libgobject-2.0.so.0
> #11 0x00002b61af7af989 in g_signal_emit_valist ()
>   from /usr/lib64/libgobject-2.0.so.0
> #12 0x00002b61af7b0043 in g_signal_emit () from /usr/lib64/libgobject-2.0.so.0
> #13 0x00002b61ae334ff5 in ?? () from /usr/lib64/libgtk-x11-2.0.so.0
> #14 0x00002b61ae226ef2 in gtk_propagate_event ()
>   from /usr/lib64/libgtk-x11-2.0.so.0
> #15 0x00002b61ae227e95 in gtk_main_do_event ()
>   from /usr/lib64/libgtk-x11-2.0.so.0
> #16 0x00002b61aea307bc in ?? () from /usr/lib64/libgdk-x11-2.0.so.0
> #17 0x00002b61afe0c064 in g_main_context_dispatch ()
>   from /usr/lib64/libglib-2.0.so.0
> #18 0x00002b61afe0f35d in ?? () from /usr/lib64/libglib-2.0.so.0
> #19 0x00002b61afe0f657 in g_main_loop_run () from /usr/lib64/libglib-2.0.so.0
> #20 0x00002b61ae228263 in gtk_main () from /usr/lib64/libgtk-x11-2.0.so.0
> #21 0x000000000040a7c5 in main (ac=2, av=0x7ffffd048228)
>    at /local/linsrc/tmp/linux-2.6.29-rc6-git5/scripts/kconfig/gconf.c:1609
>
>
> --
> ~Randy
>

-- 
Cheng Renquan (程任全), from Shenzhen, China
Groucho Marx  - "I have had a perfectly wonderful evening, but this wasn't it."
