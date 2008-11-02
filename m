Return-Path: <linux-kernel-owner+w=401wt.eu-S1754122AbYKBQvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122AbYKBQvG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 11:51:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbYKBQuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 11:50:54 -0500
Received: from mail.gmx.net ([213.165.64.20]:52920 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753681AbYKBQux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 11:50:53 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX191lEZThil1oBUUFD5Fsro6KxvRki9jE225nKq8Ac
	tjaNe6DjzM+GDN
Message-ID: <490DDA69.4000404@gmx.de>
Date: Sun, 02 Nov 2008 17:50:49 +0100
From: Helge Deller <deller@gmx.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>,
       Denys Vlasenko <vda.linux@googlemail.com>
CC: Jiri Kosina <jkosina@suse.cz>, Jeroen Roovers <jer@gentoo.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] USBHID: correct start/stop cycle
References: <1225579306-28524-1-git-send-email-jirislaby@gmail.com> <alpine.LNX.1.10.0811020000360.29633@jikos.suse.cz> <490CE128.3020007@gmail.com> <490D8467.5090206@gmx.de> <490D873D.9010005@gmail.com>
In-Reply-To: <490D873D.9010005@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> Helge Deller napsal(a):
>> Jiri Slaby wrote:
>>> On 11/02/2008 12:02 AM, Jiri Kosina wrote:
>>>> On Sat, 1 Nov 2008, Jiri Slaby wrote:
>>>>
>>>>> `stop' left out usbhid->urb* pointers and so the next `start' thought
>>>>> it needs to allocate nothing and used the memory pointers previously
>>>>> pointed to. This led to memory corruption and device malfunction.
>>> [...]
>>>> could you please verify whether this patch fixes the corruption you
>>>> were experiencing?
>>> btw. this is not expected to fix that, but if it does, the better ;).
>> I tried the patch and sadly it didn't fixed the parisc bug.
> 
> Could you bisect it?

I fully bisected it, and the final "buggy" patch seems to have been 
Denys Vlasenko's patch: cb8f488c33539f096580e202f5438a809195008f
(see 
http://github.com/jonsmirl/digispeaker/commit/cb8f488c33539f096580e202f5438a809195008f)
Denys: Any reason you removed "!prev" in front of "expand_stack" ? It 
seems wrong to remove the prev-check, else it would crash in 
expand_upwards(in the CONFIG_STACK_GROWSUP case).
This is parisc architecture (stack grows up, big-endian).

Sadly reverting just this patch, didn't fixed the bugzilla bug either: 
http://bugzilla.kernel.org/show_bug.cgi?id=11913
I think I need to redo all of my bisecting again... sigh...

Helge
