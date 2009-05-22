Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbZEVB1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbZEVB1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 21:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbZEVB1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 21:27:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:43554 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbZEVB1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 21:27:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,230,1241420400"; 
   d="scan'208";a="145675652"
From: "Xin, Xiaohui" <xiaohui.xin@intel.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Chuck Ebbert <cebbert@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, "Li, Xin" <xin.li@intel.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Date: Fri, 22 May 2009 09:26:47 +0800
Subject: RE: Performance overhead of paravirt_ops on native identified
Thread-Topic: Performance overhead of paravirt_ops on native identified
Thread-Index: AcnaZlBR8ZmC7TolTPyHS6H6r7SXWAAFcD0g
Message-ID: <C85CEDA13AB1CF4D9D597824A86D2B9005760A96DA@PDSMSX501.ccr.corp.intel.com>
References: <4A0B62F7.5030802@goop.org>
 <20090521184233.3c3e97ad@dhcp-100-2-144.bos.redhat.com>
 <4A15DA4E.2090505@goop.org>
In-Reply-To: <4A15DA4E.2090505@goop.org>
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
X-MIME-Autoconverted: from base64 to 8bit by alpha id n4M1RilL028528

Remember we have done one experiment with "jump", the result shows seems the overhead is even more than the call.

Thanks
Xiaohui

-----Original Message-----
From: Jeremy Fitzhardinge [mailto:jeremy@goop.org] 
Sent: 2009Äê5ÔÂ22ÈÕ 6:49
To: Chuck Ebbert
Cc: Ingo Molnar; Xin, Xiaohui; Li, Xin; Nakajima, Jun; H. Peter Anvin; Nick Piggin; Linux Kernel Mailing List; Xen-devel
Subject: Re: Performance overhead of paravirt_ops on native identified

Chuck Ebbert wrote:
> On Wed, 13 May 2009 17:16:55 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Paravirt patching turns all the pvops calls into direct calls, so
>> _spin_lock etc do end up having direct calls.  For example, the compiler
>> generated code for paravirtualized _spin_lock is:
>>
>> <_spin_lock+0>:		mov    %gs:0xb4c8,%rax
>> <_spin_lock+9>:		incl   0xffffffffffffe044(%rax)
>> <_spin_lock+15>:	callq  *0xffffffff805a5b30
>> <_spin_lock+22>:	retq
>>
>> The indirect call will get patched to:
>> <_spin_lock+0>:		mov    %gs:0xb4c8,%rax
>> <_spin_lock+9>:		incl   0xffffffffffffe044(%rax)
>> <_spin_lock+15>:	callq <__ticket_spin_lock>
>> <_spin_lock+20>:	nop; nop		/* or whatever 2-byte nop */
>> <_spin_lock+22>:	retq
>>
>>     
>
> Can't those calls be changed to jumps?
>   

In this specific instance of this example, yes.  But if you start 
enabling various spinlock debug options then there'll be code following 
the call.  It would be hard for the runtime patching machinery to know 
when it would be safe to do the substitution.

    J

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
