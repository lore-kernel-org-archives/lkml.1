Return-Path: <linux-kernel-owner+w=401wt.eu-S1751872AbZHJHLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbZHJHLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 03:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbZHJHLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 03:11:46 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:48728 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbZHJHLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 03:11:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pIpU8ckhKuronCB6Y30h3dD917kdyWkTki64ZrMokPMh1ua9oWonIqejLREu2yi0cN
         2ssAtmBiNeAzDpmMvC/bV3nOI6RAvTXEznt/St+SU5j5qMvEQvFsQxAf3Isk1LwH3b42
         LCxMs0Hmj+/IU2RXvKJyn7zYEuppAfCc3YPRg=
Message-ID: <4A7FC841.7060905@gmail.com>
Date: Mon, 10 Aug 2009 00:12:01 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: *** stack smashing detected ***: ./firefox-bin terminated
References: <dd18b0c30908081531k6682d5b5k14c78fa954656542@mail.gmail.com> <4A7F04B2.5000201@gmail.com>
In-Reply-To: <4A7F04B2.5000201@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> On 08/08/2009 04:31 PM, Justin Mattock wrote:
>> How should I handle this:
>>
>> *** stack smashing detected ***: ./firefox-bin terminated
>> ======= Backtrace: =========
>> /lib64/libc.so.6(__fortify_fail+0x37)[0x7f765ab2a477]
>> /lib64/libc.so.6(__fortify_fail+0x0)[0x7f765ab2a440]
>> /home/name/LFS/net/firefox/plugins/libflashplayer.so[0x7f7646911a6f]
>> /home/name/LFS/net/firefox/plugins/libflashplayer.so[0x7f764690d67c]
>> /home/name/LFS/net/firefox/plugins/libflashplayer.so[0x7f764691077f]
>> /home/name/LFS/net/firefox/plugins/libflashplayer.so[0x7f76469090cd]
>> /home/name/LFS/net/firefox/plugins/libflashplayer.so[0x7f76466f95e0]
>> /home/name/LFS/net/firefox/plugins/libflashplayer.so[0x7f76466f9c1d]
>> /home/name/LFS/net/firefox/plugins/libflashplayer.so[0x7f76466bd944]
>> /home/name/LFS/net/firefox/plugins/libflashplayer.so[0x7f76466c738b]
>> /home/name/LFS/net/firefox/plugins/libflashplayer.so[0x7f76466af3e1]
>> /home/name/LFS/net/firefox/plugins/libflashplayer.so[0x7f76466a4af0]
>> /home/name/LFS/net/firefox/plugins/libflashplayer.so[0x7f764638ed29]
>> /home/name/LFS/net/firefox/plugins/libflashplayer.so[0x7f764637edaf]
>> /usr/lib64/libglib-2.0.so.0[0x7f765bbd477b]
>> /usr/lib64/libglib-2.0.so.0(g_main_context_dispatch+0x22e)[0x7f765bbd320e] 
>>
>> /usr/lib64/libglib-2.0.so.0[0x7f765bbd3958]
>> /usr/lib64/libglib-2.0.so.0(g_main_context_iteration+0x70)[0x7f765bbd3b40] 
>>
>> ./libxul.so[0x7f765efd07a1]
>> ./libxul.so[0x7f765efd0b71]
>> ./libxul.so[0x7f765f08ea79]
>> ./libxul.so[0x7f765f0628bd]
>> ./libxul.so[0x7f765efd0883]
>> ./libxul.so[0x7f765eeaadaf]
>> ./libxul.so(XRE_main+0x213f)[0x7f765e812149]
>> ./firefox-bin[0x401bc0]
>> /lib64/libc.so.6(__libc_start_main+0xec)[0x7f765aa65a4c]
>> ./firefox-bin[0x4019b9]
>>
>> even if I move the firefox package to /usr/lib64
>> this still occurs.
>>
>> I would like to keep stack protection,
>> but having firefox crash over any flash content
>> is unattractive.
>
> Use nspluginwrapper, then Flash will run in a separate process and it 
> won't crash Firefox when it crashes (which it does fairly regularly).
>
>>
>> should I try firefox about this, or change something in the kernel?
>
> Nothing to do with the kernel, it's glibc's stack corruption detection 
> that's being triggered.
>
nice idea,
after being completely lazy, and not wanting
to go through the mess, I finally did.
(nss just needs to know where the includes are)

flash plays, the stack protection triggers
flash crashes and burns, but firefox is still
there standing. clicking on back and then to another movie
(that's stack smashing free) does the trick.

maybe libc is set to sensitive, or flash needs the -fstack-protector
switch(Ill send libc a post to see
what they say).

Thanks for the help.

Justin P. Mattock
