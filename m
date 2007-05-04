Return-Path: <linux-kernel-owner+w=401wt.eu-S1767515AbXEDASR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767515AbXEDASR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 20:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766895AbXEDASQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 20:18:16 -0400
Received: from smtpout.mac.com ([17.250.248.173]:64319 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767494AbXEDASO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 20:18:14 -0400
In-Reply-To: <Pine.LNX.4.61.0705032216200.18504@yvahk01.tjqt.qr>
References: <787b0d920704302109r352e6653wc71a0638cbfbdcce@mail.gmail.com> <Pine.LNX.4.64.0705011347300.27246@anakin> <1178021516.4372.62.camel@daplas> <46375738.1010007@zytor.com> <787b0d920705010849u52a4d6c3o2f1f800521ad5b95@mail.gmail.com> <Pine.LNX.4.61.0705021953030.18504@yvahk01.tjqt.qr> <787b0d920705022317j485cbe26wc83f071834c53584@mail.gmail.com> <Pine.LNX.4.61.0705030902430.18504@yvahk01.tjqt.qr> <787b0d920705030714k3b290d2csa38a5df63c692d6f@mail.gmail.com> <Pine.LNX.4.61.0705031621370.18504@yvahk01.tjqt.qr> <Pine.LNX.4.64.0705031754410.4727@anakin> <Pine.LNX.4.61.0705032020130.18504@yvahk01.tjqt.qr> <463A42DF.5030409@zytor.com> <Pine.LNX.4.61.0705032216200.18504@yvahk01.tjqt.qr>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <E0FF8D28-219F-44D5-88B4-BDE6A4D6605A@mac.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Albert Cahalan <acahalan@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, aeb@cwi.nl
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: console font limits
Date: Thu, 3 May 2007 20:17:48 -0400
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 03, 2007, at 16:16:51, Jan Engelhardt wrote:
> On May 3 2007 13:15, H. Peter Anvin wrote:
>> Jan Engelhardt wrote:
>>>
>>>> Put people didn't like that, and disabled text output when the  
>>>> console is in KD_GRAPHICS mode...
>>>
>>> at the cost of not getting the kernel oops, heh.
>>
>> I thought the reason we didn't display text in KD_GRAPHICS mode  
>> was that KD_GRAPHICS might mean "in a completely different mode  
>> that only userspace knows about."
>
> Hrm. Maybe we need a distinction into KD_KGRAPHICS and KD_UGRAPHICS  
> then.

Actually I think the real problem was that "KD_GRAPHICS" got  
overloaded to mean "some userspace program is probably poking at the  
GPU in very direct ways possibly including /dev/mem".  As such it  
really isn't safe at all for the kernel to write stuff to the screen  
in that situation; you could turn a panic()+reboot-after-30-secs into  
an unrecoverable hard PCI bus lockup.  IIRC there were at least a  
couple chipsets which had that problem with X.  If we can implement  
enough APIs for X to do all of its stuff from userspace without iopl 
() or /dev/mem then we could probably bring back the option for  
dumping oopses to screen in KD_GRAPHICS mode, but otherwise it'll  
just cause more headaches.

Cheers,
Kyle Moffett

