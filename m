Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbYE0Ftz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbYE0Ftz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 01:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753522AbYE0Ftq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 01:49:46 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:37944 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbYE0Ftp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 01:49:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PcWnXC/e5YdMQYKWflEo0QqOyON3ltxBuLS7/IYJe6J0k/FcB2Z0IOuRRKzSqDyysucClAVsdlswTqvcn+fQaMJQqAExk7vUhMUF81FUckiMQJjbCkKJXN+Iaf3r2o26yXdDNK1uIb9eMkUTSoceX3/6r66J0U/MAZhI8/AVzeA=
Message-ID: <3877989d0805262249yab130cbyfc5f5e54065cec5c@mail.gmail.com>
Date: Tue, 27 May 2008 13:49:44 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Roland McGrath" <roland@redhat.com>
Subject: Re: [RFC PATCH] set TASK_TRACED before arch_ptrace code to fix a race
Cc: "Petr Tesarik" <ptesarik@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
In-Reply-To: <20080527040454.053C526FA9E@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3877989d0805211947i54bacc7cv619541e9b40824fb@mail.gmail.com>
	 <3877989d0805220624i259a9d1j708795c65c636ca0@mail.gmail.com>
	 <20080522203428.835D626FA24@magilla.localdomain>
	 <3877989d0805222042p176da844k384ea512b1cfb0da@mail.gmail.com>
	 <20080523041940.39E8726FA24@magilla.localdomain>
	 <3877989d0805222224n77ce36b6wdf15c4bab330a0f8@mail.gmail.com>
	 <20080526001527.81E1126FA9E@magilla.localdomain>
	 <3877989d0805251830w70f19e4cu46fbc32148217749@mail.gmail.com>
	 <3877989d0805262031i29db16bcjfa31652afc746b49@mail.gmail.com>
	 <20080527040454.053C526FA9E@magilla.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>> It does happen!!
>
> Um.  Really?  What does happen exactly?

I revised patch a bit, and managed to get this:

Call Trace:
 [<a000000100011bd0>] show_stack+0x50/0xa0
                                sp=e000000141c9fbb0 bsp=e000000141c90ea8
 [<a000000100011c50>] dump_stack+0x30/0x60
                                sp=e000000141c9fd80 bsp=e000000141c90e90
 [<a000000100097a20>] get_signal_to_deliver+0xa0/0x720
                                sp=e000000141c9fd80 bsp=e000000141c90e28
 [<a0000001000343d0>] ia64_do_signal+0xb0/0xd00
                                sp=e000000141c9fd80 bsp=e000000141c90d78
 [<a000000100012650>] do_notify_resume_user+0xf0/0x140
                                sp=e000000141c9fe20 bsp=e000000141c90d48
 [<a00000010000aac0>] notify_resume_user+0x40/0x60
                                sp=e000000141c9fe20 bsp=e000000141c90cf8
 [<a00000010000a9f0>] skip_rbs_switch+0xe0/0x110
                                sp=e000000141c9fe30 bsp=e000000141c90cf8
 [<a000000000010740>] __kernel_syscall_via_break+0x0/0x20
                                sp=e000000141ca0000 bsp=e000000141c90cf8
 [<a0000001000971c0>] ptrace_stop+0xa0/0x3e0
                                sp=e00000014716fdb0 bsp=e000000147160ca8
 [<a000000100097650>] ptrace_notify+0x150/0x1c0
                                sp=e00000014716fdb0 bsp=e000000147160c88
 [<a00000010002adb0>] syscall_trace+0x30/0xc0
                                sp=e00000014716fe30 bsp=e000000147160c70
 [<a00000010002aea0>] syscall_trace_enter+0x60/0xa0
                                sp=e00000014716fe30 bsp=e000000147160c18
 [<a00000010000a300>] ia64_trace_syscall+0x40/0x110
                                sp=e00000014716fe30 bsp=e000000147160c18
 [<a000000000010740>] __kernel_syscall_via_break+0x0/0x20
                                sp=e000000147170000 bsp=e000000147160c18
