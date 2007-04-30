Return-Path: <linux-kernel-owner+w=401wt.eu-S1423215AbXD3M7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423215AbXD3M7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 08:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423223AbXD3M7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 08:59:01 -0400
Received: from mpc-26.sohonet.co.uk ([193.203.82.251]:47999 "EHLO
	moving-picture.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423215AbXD3M67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 08:58:59 -0400
Message-ID: <4635E810.80809@moving-picture.com>
Date: Mon, 30 Apr 2007 13:58:56 +0100
From: James Pearson <james-p@moving-picture.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040524
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Antonino A. Daplas" <adaplas@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: X display shift with disabled console blanking
References: <46322E08.3040303@moving-picture.com> <1177727097.7568.6.camel@daplas>
In-Reply-To: <1177727097.7568.6.camel@daplas>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Disclaimer: This email and any attachments are confidential, may be legally
X-Disclaimer: privileged and intended solely for the use of addressee. If you
X-Disclaimer: are not the intended recipient of this message, any disclosure,
X-Disclaimer: copying, distribution or any action taken in reliance on it is
X-Disclaimer: strictly prohibited and may be unlawful. If you have received
X-Disclaimer: this message in error, please notify the sender and delete all
X-Disclaimer: copies from your system.
X-Disclaimer: 
X-Disclaimer: Email may be susceptible to data corruption, interception and
X-Disclaimer: unauthorised amendment, and we do not accept liability for any
X-Disclaimer: such corruption, interception or amendment or the consequences
X-Disclaimer: thereof.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Antonino A. Daplas wrote:
> On Fri, 2007-04-27 at 18:08 +0100, James Pearson wrote:
> 
>>I have a problem whereby the X display 'shifts' to left when anything 
>>writes to /dev/console - where console screen blanking has been disabled 
>>i.e. doing something like:
>>
>>boot to run level 3
>>
>>If not root, then make sure /dev/console is writeable
>>
>>login and type:
>>
>>setterm -blank 0
>>
>>start X
>>
>>type into an xterm:
>>
>>echo "some random text" > /dev/console
>>(may have to repeat the echo above a few times)
>>
>>... and the whole X display jumps (and wraps) to the left
>>
>>I'm using a RHEL4 based distro with a vanilla 2.6.21 x86_64 kernel 
>>(although I've seen the problem with various x86_64 and i686 2.6.X kernels).
>>
>>I've seen this problem on a number of different nVidia cards - using 
>>the vesa driver (same problem occurs with nVidia's binary driver). I 
>>haven't tried using other makes of graphics cards.
>>
>>
>>OK, this may be a strange combination of disabling the text console 
>>blanking and running X, but something isn't right somewhere ...
> 
> 
> Yep, it's strange because I can't reproduce this. And the console write
> should not succeed if the current console is in KD_GRAPHICS mode, which
> is done by X (unless your version is different).

I've just installed a vanilla CentOS 4.4 on an i686 SMP machine - with 
an nVidia Quadro4 980 XGL card.

By default, this sets up X using the 'nv' driver (using RedHat's 
xorg-x11-6.8.2-1.EL.13.37).

If I follow my 'recipe' above, then the screen shifts - note: it looks 
like you have to write several lines of text to /dev/console (at least 
30) to trigger the problem (e.g. run the echo to /dev/console in a loop) 
- also, I've found that switching to the console and back to X 
(Ctrl-Alt-F1 then Ctrl-Alt-F7) while this echo loop is running can force 
the shift to start ...

This is with the RedHat based 2.6.9-42.ELsmp kernel - but I also get the 
problem with a vanilla 2.6.21 kernel.

>>Any ideas?
> 
> 
> I don't.  But, what is your current console?  Is it VGA, or framebuffer?
> Can you try doing this again in both VGA and vesafb?

I'm not sure what the current console is - whatever is the default with 
RHEL4/CentOS4 - how do I select a different type of console?

> And this does not happen if there is no previous setterm -blank 0
> command?

It doesn't happen if there is no previous 'setterm -blank 0' - so, 
arguably, this is the 'fix' ...

James Pearson
