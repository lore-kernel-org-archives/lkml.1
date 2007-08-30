Return-Path: <linux-kernel-owner+w=401wt.eu-S1761323AbXH3OYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761323AbXH3OYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 10:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbXH3OYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 10:24:05 -0400
Received: from mpc-26.sohonet.co.uk ([193.203.82.251]:43736 "EHLO
	moving-picture.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752378AbXH3OYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 10:24:03 -0400
X-Greylist: delayed 1810 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Aug 2007 10:24:03 EDT
Message-ID: <46D6CBED.4040301@moving-picture.com>
Date: Thu, 30 Aug 2007 14:53:49 +0100
From: James Pearson <james-p@moving-picture.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040524
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Guy Streeter <guy.streeter@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 4096 byte limit to /proc/PID/environ ?
References: <4474B7DB.8000304@moving-picture.com>	 <200605242029.k4OKTn9C031700@terminus.zytor.com>	 <447EF58C.6000605@moving-picture.com> <52dd17640708150954q798d137cn1b07739785917c5b@mail.gmail.com> <46C33700.1060605@zytor.com>
In-Reply-To: <46C33700.1060605@zytor.com>
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

H. Peter Anvin wrote:
> Guy Streeter wrote:
> 
>>On 6/1/06, James Pearson <james-p@moving-picture.com> wrote:
>>
>>>H. Peter Anvin wrote:
>>>
>>>>I think this is the wrong approach.
>>>>
>>>>Many of these should probably be converted to seq_file, but in the
>>>>particular case of environ, the right approach is to observe the fact
>>>>that reading environ is just like reading /proc/PID/mem, except:
>>>>
>>>> a. the access restrictions are less strict, and
>>>> b. there is a range restriction, which needs to be enforced, and
>>>> c. there is an offset.
>>>>
>>>>Pretty much, take the guts from /proc/PID/mem and generalize it
>>>>slightly, and you have the code that can run either /proc/PID/mem or
>>>>/proc/PID/environ.
>>>
>>>The following patch is based on the /proc/PID/mem code appears to work fine.
>>>
>>
>>This thread has gone stale. The PAGE_SIZE limit still exists. Is this
>>solution acceptable?
>>
> 
> 
> Can we avoid the code duplication?

There isn't that much that is duplicated - and there are also bits of 
the /proc/PID/mem code that are not needed in this case, so I'm not 
really sure if it is worth doing.

I did submit a patch a few months ago - see:

<http://marc.info/?l=linux-kernel&m=117862109623007&w=2>

James Pearson
