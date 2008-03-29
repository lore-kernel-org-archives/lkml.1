Return-Path: <linux-kernel-owner+w=401wt.eu-S1757894AbYC2AHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbYC2AHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 20:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbYC2AHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 20:07:36 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:36203 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbYC2AHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 20:07:35 -0400
Date: Sat, 29 Mar 2008 01:07:34 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: "John T." <j.thomast@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: UTF-8 and Alt key in the console
In-Reply-To: <47ED7EBD.8070009@zytor.com>
Message-ID: <alpine.LNX.1.10.0803290055270.18418@fbirervta.pbzchgretzou.qr>
References: <205509.99433.qm@web45710.mail.sp1.yahoo.com> <alpine.LNX.1.00.0803231942380.3157@fbirervta.pbzchgretzou.qr> <47ED7EBD.8070009@zytor.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Saturday 2008-03-29 00:26, H. Peter Anvin wrote:
>>
>>  About the ESC key, I thought, would it suffice to replace its
>>  current output of ^[ with ^[^[?
>
> It would be better to assign a CSI (ESC [) code to it, like other function 
> keys.  Unfortunately, the terminal everyone tries to emulate (Linux does so 
> quite poorly due to its broken implementation of ISO 2022, but that's less of 
> an issue with UTF-8), VT 220, had ESC on the F11 key, so the CSI 2 3 ~ 
> sequence it uses we use for the F11 key. Doesn't mean we can't assign another 
> one.

Even so, the linux term is the least broken one of all. I often had
issues with remote login programs (largely Windows ones) that had a
different idea of VTxxx whenever you wished not to have it. Despite
TERM being vt100 and the local encoding being vt100 too, actual
escape sequences were different from what programs in the shell
expected. On one occassion, F keys worked, but the Ins/Home does not,
in another it was reversed, etc. As soon as I learnt of putty a
few years ago I was happy to have all the mess that windows ssh
programs cause solved because it implemented the "linux" term type
and that just seemed to work out-of-the-box. So it does not seem
as broken to me as VTxxx.

> One would also like to distinguish, say, Backspace from Ctrl-H.  This is 
> trickier, because the termios settings don't permit compound keys.  The most 
> obvious way to deal with that is an escape code for Ctrl-H, but that has the 
> risk of breaking a lot of other things.

Like what? I know that ^H is abused for screen effects.. not much
you can do about it, but it is not that important anyway.

As for ^H, all that I think is needed is the generation of an
appropriate escape code for Ctrl-H and Backspace at the terminal
emulator level (read: a pure xterm thing what key gets translated
into what escape code), while the read side then interprets
"ESC CTRLH", "ESC BKSP" and the traditional "^H".

And while we are at it, I'd suggest a whole new set of escape
codes, the current sequences are particularly... bad for
stream synchronization. Right now one has to parse strings for
end-of-escape.. which is awkward. I'd just be able to
strchr(s, '^]') for example and know when the escape code
ends. (Compat should of course be honored where necessary.)
