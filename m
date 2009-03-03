Return-Path: <linux-kernel-owner+w=401wt.eu-S1756523AbZCCTyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbZCCTyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 14:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755862AbZCCTyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 14:54:20 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:53066 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbZCCTyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 14:54:18 -0500
Message-ID: <49AD8B2F.4060700@oracle.com>
Date: Tue, 03 Mar 2009 11:55:27 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Cheng Renquan <crquan@gmail.com>
CC: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] [KBUILD] configuration system improvements
References: <1235401804-8136-1-git-send-email-crquan@gmail.com>	 <49AB55B9.3050301@oracle.com> <91b13c310903022009l363497bbi380356c19caa53b3@mail.gmail.com> <49AD75D4.20600@oracle.com>
In-Reply-To: <49AD75D4.20600@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.49AD8AD6.024E:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> Cheng Renquan wrote:
>> On Mon, Mar 2, 2009 at 11:42 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>> Cheng Renquan wrote:
>>>> This group of patches improve the usability of kernel configuration system,
>>>> mainly,
>>>>
>>>> 1. add symbol's value shown accompanied in config item's help message;
>>>> 2. move the real plumbing functions code from mconf.c to menu.c, make them
>>>>    be able to be shared with other configuration methods;
>>>> 3. add "symbol's value shown" support for gconfig/xconfig/config;
>>>>
>>>>   0001--KBUILD-add-symbol-value-to-help-find-the-real-depe.patch
>>>>   0002--KBUILD-add-menu_get_ext_help-function-to-display-m.patch
>>>>   0003--KBUILD-menuconfig-improvements.patch
>>>>   0004--KBUILD-make-use-of-menu_get_ext_help-in-gconfig.patch
>>>>   0005--KBUILD-make-use-of-menu_get_ext_help-in-qconfig.patch
>>>>   0006--KBUILD-make-use-of-menu_get_ext_help-in-make-conf.patch
>>>>
>>>> I found gconfig still lack of "search by symbol" support, and that would be
>>>> in another patch.
>>>>
>>>> Request for comments, thanks.
>>> Hi,
>>>
>>> I still like this idea a lot.  However, with "make gconfig" I am
>>> seeing a segfault when I click on "Firmware Drivers" in the main menu.
>>> I only see this with these patches applied.
>>>
>>> Other than that, they look good to me.
>>>
>>>
>>> Here's the gconfig info:
>>> rddunlap@chimera:linux-2.6.29-rc6-git5> make ARCH=x86_64 O=xx64 gconfig &
>>> [1] 10722
>>> rddunlap@chimera:linux-2.6.29-rc6-git5>   GEN     /local/linsrc/tmp/linux-2.6.29-rc6-git5/xx64/Makefile
>>> scripts/kconfig/gconf arch/x86/Kconfig
>>> make[2]: *** [gconfig] Segmentation fault
>>> make[1]: *** [gconfig] Error 2
>>> make: *** [sub-make] Error
>>>
>>>
>>> and from the kernel log:
>>>
>>> gconf[10868]: segfault at 0000000000000070 rip 00000000004111b6 rsp 00007ffff67cd6f0 error 4
>> Could you tell what distribution are you using? The versions of your
>> glibc, gtk+2.0, and glibc? If you can correctly build other gtk+
>> programs?
> 
> This is on OpenSUSE 10.3 on x86_64.
> 
> glibc-2.6.1-18
> gtk2-2.12.0-5
> 
> I don't know that I have any other gtk+ programs.
> 
>> I have developed these patches on default Fedora 10 i686, it runs
>> well, and today I have tested it under a latest Gentoo x86_64 desktop,
>> all seems run well here.
> 
> Here's a backtrace from gdb.  gconfig was built without -d, however.

Here's a better backtrace; gconfig was built with -g (not -d ??!?).

Program received signal SIGSEGV, Segmentation fault.
0x00000000004111b6 in get_symbol_str ()
(gdb) #0  0x00000000004111b6 in get_symbol_str ()
#1  0x0000000000408acb in on_treeview2_cursor_changed (
    treeview=<value optimized out>, user_data=<value optimized out>)
    at /local/linsrc/tmp/linux-2.6.29-rc6-git5/scripts/kconfig/gconf.c:461
#2  0x00002b61af79bd2f in g_closure_invoke ()
   from /usr/lib64/libgobject-2.0.so.0
#3  0x00002b61af7ae1fd in ?? () from /usr/lib64/libgobject-2.0.so.0
#4  0x00002b61af7afc55 in g_signal_emit_valist ()
   from /usr/lib64/libgobject-2.0.so.0
#5  0x00002b61af7b0043 in g_signal_emit () from /usr/lib64/libgobject-2.0.so.0
#6  0x00002b61ae31bada in ?? () from /usr/lib64/libgtk-x11-2.0.so.0
#7  0x00002b61ae3225de in ?? () from /usr/lib64/libgtk-x11-2.0.so.0
#8  0x00002b61ae22dbbf in ?? () from /usr/lib64/libgtk-x11-2.0.so.0
#9  0x00002b61af79bd2f in g_closure_invoke ()
   from /usr/lib64/libgobject-2.0.so.0
#10 0x00002b61af7ae5f6 in ?? () from /usr/lib64/libgobject-2.0.so.0
#11 0x00002b61af7af989 in g_signal_emit_valist ()
   from /usr/lib64/libgobject-2.0.so.0
#12 0x00002b61af7b0043 in g_signal_emit () from /usr/lib64/libgobject-2.0.so.0
#13 0x00002b61ae334ff5 in ?? () from /usr/lib64/libgtk-x11-2.0.so.0
#14 0x00002b61ae226ef2 in gtk_propagate_event ()
   from /usr/lib64/libgtk-x11-2.0.so.0
#15 0x00002b61ae227e95 in gtk_main_do_event ()
   from /usr/lib64/libgtk-x11-2.0.so.0
#16 0x00002b61aea307bc in ?? () from /usr/lib64/libgdk-x11-2.0.so.0
#17 0x00002b61afe0c064 in g_main_context_dispatch ()
   from /usr/lib64/libglib-2.0.so.0
#18 0x00002b61afe0f35d in ?? () from /usr/lib64/libglib-2.0.so.0
#19 0x00002b61afe0f657 in g_main_loop_run () from /usr/lib64/libglib-2.0.so.0
#20 0x00002b61ae228263 in gtk_main () from /usr/lib64/libgtk-x11-2.0.so.0
#21 0x000000000040a7c5 in main (ac=2, av=0x7ffffd048228)
    at /local/linsrc/tmp/linux-2.6.29-rc6-git5/scripts/kconfig/gconf.c:1609


-- 
~Randy
