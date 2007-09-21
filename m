Return-Path: <linux-kernel-owner+w=401wt.eu-S1761406AbXIUPru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761406AbXIUPru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 11:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759122AbXIUPrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 11:47:42 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:50921 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758801AbXIUPrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 11:47:41 -0400
Message-ID: <46F3E79B.7030305@grupopie.com>
Date: Fri, 21 Sep 2007 16:47:39 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Satyam Sharma <satyam@infradead.org>, Gilboa Davara <gilboad@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Reduce __print_symbol/sprint_symbol stack usage.
References: <1189856129.18191.11.camel@gilboa-home-dev.localdomain> <a781481a0709150602v6be754caw4fbe0f76c8db5beb@mail.gmail.com> <1189869329.18191.77.camel@gilboa-home-dev.localdomain> <1189879681.18191.93.camel@gilboa-home-dev.localdomain> <alpine.LFD.0.999.0709190610540.26241@enigma.security.iitk.ac.in> <46F1314B.8040105@grupopie.com> <20070921145628.GE15697@goodmis.org>
In-Reply-To: <20070921145628.GE15697@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Wed, Sep 19, 2007 at 03:25:15PM +0100, Paulo Marques wrote:
>> if we change the interface from "print_symbol(fmt, addr)" to 
>> "print_symbol(prefix, addr, int newline)" we can simply do:
>>
>> printk(prefix);
>> printk_symbol(addr);
>> if (newline)
>> 	printk("\n");
> 
> NACK
> 
> I just wrote something that does "print_symbol(" %s)\n", addr);"
> Notice the ")" in the output.

We can just change that to "print_symbol(prefix, addr, suffix)" instead. 
The concept is basically the same (and I wasn't very fond of that 
newline argument either).

As an added bonus we stop needing an extra layer to check that the 
string passed is in the right format with a single "%s" in it.

-- 
Paulo Marques - www.grupopie.com

"Very funny Scotty. Now beam up my clothes."
