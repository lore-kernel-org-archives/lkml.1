Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbZEVGAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbZEVGAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 02:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbZEVGAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 02:00:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:38438 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbZEVGAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 02:00:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,231,1241420400"; 
   d="scan'208";a="459534866"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Chuck Ebbert <cebbert@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "Li, Xin" <xin.li@intel.com>, "Nakajima, Jun" <jun.nakajima@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Date: Fri, 22 May 2009 13:59:42 +0800
Subject: RE: Performance overhead of paravirt_ops on native identified
Thread-Topic: Performance overhead of paravirt_ops on native identified
Thread-Index: AcnalaaE5TVoYk48Qv+MGvUsKaOYBwADHAwQ
Message-ID: <C85CEDA13AB1CF4D9D597824A86D2B9005760A9940@PDSMSX501.ccr.corp.intel.com>
References: <4A0B62F7.5030802@goop.org>
 <20090521184233.3c3e97ad@dhcp-100-2-144.bos.redhat.com>
 <4A15DA4E.2090505@goop.org>
 <C85CEDA13AB1CF4D9D597824A86D2B9005760A96DA@PDSMSX501.ccr.corp.intel.com>
 <4A1629BA.9070309@goop.org>
In-Reply-To: <4A1629BA.9070309@goop.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n4M60llL030695

What I mean is that if the binary of _spin_lock is like this:
(gdb) disassemble _spin_lock
Dump of assembler code for function _spin_lock:
0xffffffff80497c0f <_spin_lock+0>:      mov    1252634(%rip),%r11        # #0xffffffff805c9930 <test_lock_ops+16>
0xffffffff80497c16 <_spin_lock+7>:      jmpq   *%r11
End of assembler dump.
(gdb) disassemble

In this situation the binary contains a jump, the overhead is more than the call.

Thanks
Xiaohui

-----Original Message-----
From: Jeremy Fitzhardinge [mailto:jeremy@goop.org] 
Sent: 2009Äê5ÔÂ22ÈÕ 12:28
To: Xin, Xiaohui
Cc: Chuck Ebbert; Ingo Molnar; Li, Xin; Nakajima, Jun; H. Peter Anvin; Nick Piggin; Linux Kernel Mailing List; Xen-devel
Subject: Re: Performance overhead of paravirt_ops on native identified

Xin, Xiaohui wrote:
> Remember we have done one experiment with "jump", the result shows seems the overhead is even more than the call.
>   

I don't think you had mentioned that. You're saying that a
call->jmp->ret is slower than call->call->ret->ret?

J
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
