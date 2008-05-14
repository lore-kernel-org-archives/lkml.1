Return-Path: <linux-kernel-owner+w=401wt.eu-S1761005AbYENRSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761005AbYENRSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 13:18:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbYENRRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 13:17:54 -0400
Received: from po-out-1718.google.com ([72.14.252.159]:57292 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750AbYENRRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 13:17:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fPvj7z7Zzl0QFo18vquwCM58mvhC4i4gyyOTfumcC/SHtwbxBN88lJ/D2+QDeXI6iAYJXANdu35Rgs5SOmghOqWyitm2RuUf8/Ot/f6aikBpLQP1eY6AJe46TaJ6yI6e/+fm0Q7lANP2FC/yHWtcKUHh0404JeUdJQbq16BH2dc=
Message-ID: <19f34abd0805141017g26c13e96t2e7edc23bec263d0@mail.gmail.com>
Date: Wed, 14 May 2008 19:17:53 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Harald Dunkel" <harald.dunkel@t-online.de>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.25.3: su gets stuck for root
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <482B1BD2.8040400@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4829326A.6060808@t-online.de>
	 <19f34abd0805122347x4d9c5d03m16679d724189790e@mail.gmail.com>
	 <4829D345.7020909@t-online.de>
	 <19f34abd0805140034j75d97ecbw5a03c200645768cb@mail.gmail.com>
	 <482B1BD2.8040400@t-online.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 7:05 PM, Harald Dunkel
<harald.dunkel@t-online.de> wrote:
> Vegard Nossum wrote:
>>
>> Ah, tough luck. What if you attach an strace to the already stuck
>> process? Like strace -p pid. It's a long shot, but worth a try, I
>> suppose.
>>
>
> As suggested I attached strace to the blocking stty. I got a
> continuous flow of
>
> :
> :
> ioctl(0, SNDCTL_TMR_STOP or TCSETSW, {B38400 opost isig icanon echo ...}) =
> ? ERESTARTSYS (To be restarted)
> --- SIGTTOU (Stopped (tty output)) @ 0 (0) ---
> --- SIGTTOU (Stopped (tty output)) @ 0 (0) ---
> :
> :
>
> I also moved back to an old version of coreutils from about
> 4 months ago. Same result.

Looks good. Adding Alan Cox to conversation. Original report:

--------
If I run "su someuser" as root, then it gets stuck. No prompt. I cannot
interrupt it with ^C or ^Z either. /var/log/auth.log says:

May 13 08:06:41 pluto su[4193]: Successful su for root by harri
May 13 08:06:41 pluto su[4193]: + pts/3 harri:root
May 13 08:06:41 pluto su[4193]: pam_unix(su:session): session opened
for user root by harri(uid=1000)

ps shows:

% ps -ef | grep pts/3
harri     4007  4006  0 07:58 pts/3    00:00:00 bash
root      4193  4007  0 08:06 pts/3    00:00:00 su
root      4194  4193  0 08:06 pts/3    00:00:00 bash
root      4209  4194  0 08:08 pts/3    00:00:00 su
root      4210  4209  0 08:08 pts/3    00:00:00 bash
root      4217  4210  0 08:08 pts/3    00:00:00 stty intr ^C

So obviously 'stty' is to blame here (called from root's .bashrc, as
it seems). But for 2.6.24.4 there is no such problem.
--------


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
