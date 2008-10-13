Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbYJMOvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbYJMOvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 10:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355AbYJMOu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 10:50:59 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:4623 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921AbYJMOu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 10:50:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=QnZbqW0RgCPHyFulHNvovlJXkLoTZTXmArTUCLFOV1kYDLrtau3dVWwmAjIKwypW6/
         jE+hsBRe+Q+80cLxxU3grfZcIsKa85rhM1KGNx2WtzXNZ3UR7CJsdKeoFGXMDGHahBMn
         BwL1aHwdRKiq4pw+mTBk0LGzuvPzdWb7/0d3k=
Message-ID: <48F3604B.8050105@gmail.com>
Date: Mon, 13 Oct 2008 16:50:51 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: GIT head no longer boots on x86-64
References: <20081013112024.0183f982@lxorguk.ukuu.org.uk> <1223895414-19793-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.2.00.0810130740360.3288@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810130740360.3288@nehalem.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2008 04:45 PM, Linus Torvalds wrote:
> 
> On Mon, 13 Oct 2008, Jiri Slaby wrote:
>> +	sprint_symbol(buf, (unsigned long)__builtin_return_address(0));
>> +	if (!is_vmalloc_addr(vmalloc_addr) && !is_module_address(addr))
>> +		printk("BUG? %s (from %s): %p\n", __func__, buf, vmalloc_addr);
> 
> Just use
> 
> 	printk("BUG? %s (from %pS): %p\n",
> 		__func__,
> 		__builtin_return_address(0),
> 		vmalloc_addr);
> 
> and don't ever sprint_symbol() any more. 

Ok, thanks, I knew about it, but didn't remember it while I was hacking that
debug patch.
