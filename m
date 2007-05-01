Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbXEAP6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbXEAP6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 11:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbXEAP6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 11:58:51 -0400
Received: from mpc-26.sohonet.co.uk ([193.203.82.251]:55386 "EHLO
	moving-picture.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753253AbXEAP6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 11:58:50 -0400
Message-ID: <463763B8.7060606@moving-picture.com>
Date: Tue, 01 May 2007 16:58:48 +0100
From: James Pearson <james-p@moving-picture.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040524
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Antonino A. Daplas" <adaplas@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: X display shift with disabled console blanking
References: <46322E08.3040303@moving-picture.com>	 <1177727097.7568.6.camel@daplas>  <4635E810.80809@moving-picture.com>	 <1177969865.4372.23.camel@daplas>  <46372FC3.6090807@moving-picture.com> <1178032840.5331.2.camel@daplas>
In-Reply-To: <1178032840.5331.2.camel@daplas>
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
> On Tue, 2007-05-01 at 13:17 +0100, James Pearson wrote:
> 
>>Antonino A. Daplas wrote:
>>
>>>On Mon, 2007-04-30 at 13:58 +0100, James Pearson wrote:
>>>
>>>
>>>>Antonino A. Daplas wrote:
>>>>
>>>>
>>>>>On Fri, 2007-04-27 at 18:08 +0100, James Pearson wrote:
> 
> 
>>It does indeed seem that the switching back and forth between text and 
>>graphics does appear to be part of the issue - in my previous testing I 
>>probably did do this (but didn't include this in my recipe above) - so 
>>here is a new 'recipe' that shows the problem (for me)
>>
>>boot to run level 3
>>
>>if not root, then make sure /dev/console is writeable
>>
>>login and type:
>>
>>setterm -blank 0
>>
>>start X
>>
>>type into an xterm:
>>
>>while true; do echo "" > /dev/console; usleep 100000; done
>>
>>while the above loop is running switch to the text console and back 
>>again (Ctrl-Alt-F1 then Ctrl-Alt-F7)
>>
>>... and the screen will be shifting (and wrapping) to the left.
>>
> 
> 
> Okay, this makes me see the problem more clearly.  It looks like that
> vt/console layer is unreliable in terms of checking for the
> text/graphics mode of the current console.  Instead of auditing the
> console code, I'll just have vgacon check for the mode.  Try the
> attached patch and let me know if it helps. 

That seems to fix it!

Thanks

James Pearson
