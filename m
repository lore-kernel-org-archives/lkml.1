Return-Path: <linux-kernel-owner+w=401wt.eu-S965289AbXDCA4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965289AbXDCA4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 20:56:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933945AbXDCA4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 20:56:00 -0400
Received: from terminus.zytor.com ([192.83.249.54]:39077 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933940AbXDCA4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 20:56:00 -0400
Message-ID: <4611A60F.90505@zytor.com>
Date: Mon, 02 Apr 2007 17:55:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: "Antonino A. Daplas" <adaplas@gmail.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Paul LeoNerd Evans <leonerd@leonerd.org.uk>
Subject: Re: [PATCH] vt: Do not clear UTF when resetting console
References: <46110F88.5040905@gmail.com>  <46113ED6.4060005@zytor.com> <1175559377.7267.13.camel@daplas> <Pine.LNX.4.61.0704030220140.18387@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704030220140.18387@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Apr 3 2007 08:16, Antonino A. Daplas wrote:
>> That would be the cleanest and purest behavior. But it's possible to set
>> one console to UTF-8 and another to legacy mode.
> 
> The question would be: why would you want to have mixed consoles?
> Switching to UTF8 IMO does not take away any characters, and I mean
> no-framebuffer 80x25 that is limited to 256 glyphs.
> 

512, not 256.  However, the reason would be because you have an 
application (which might actually be running on another system 
entirely!) which expects the other behaviour.

Antonio wrote:
> That would be the cleanest and purest behavior. But it's possible to set
> one console to UTF-8 and another to legacy mode. So one can corrupt the
> user's console just by issuing a reset or echo -e '\033c'. (Although one
> can argue that users who know what UTF-8 is also knows how to set the
> encoding back)
> 
> Until userspace is more capable of setting back the terminal to its
> previous configuration, I would tend to agree with Jan, that we should
> leave the current utf setting of that particular vc alone.

I think you're missing the whole point of console reset.  Its purpose is 
to force the console into a known-good state.  The fewer pieces of state 
it leaves unset, the better.  To some degree it's less important what 
that state actually is.

	-hpa
