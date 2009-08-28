Return-Path: <linux-kernel-owner+w=401wt.eu-S1751438AbZH1VUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbZH1VUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 17:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbZH1VUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 17:20:41 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:44569 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbZH1VUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 17:20:41 -0400
Message-ID: <4A984A05.9080009@nortel.com>
Date: Fri, 28 Aug 2009 15:20:05 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Christoph Lameter <cl@linux-foundation.org>,
       raz ben yehuda <raziebe@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       peterz@infradead.org, maximlevitsky@gmail.com, efault@gmx.de,
       riel@redhat.com, wiseman@macs.biu.ac.il, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: RFC: THE OFFLINE SCHEDULER
References: <1251282598.3514.20.camel@raz>  <alpine.DEB.1.10.0908260943090.9924@gentwo.org>  <1251297910.1791.22.camel@maxim-laptop> <1251298443.4791.7.camel@raz>  <1251300625.18584.18.camel@twins>  <alpine.DEB.1.10.0908261136590.9933@gentwo.org>  <1251302598.18584.31.camel@twins>  <alpine.DEB.1.10.0908261211340.9933@gentwo.org>  <20090826180407.GA13632@elte.hu>  <alpine.DEB.1.10.0908261509580.9933@gentwo.org>  <20090826193252.GA14721@elte.hu>  <alpine.DEB.1.10.0908261627110.5554@gentwo.org>  <20090826135041.e6169d18.akpm@linux-foundation.org>  <4A95A5EE.90400@nortel.com> <1251322663.3882.48.camel@raz> <4A96B997.1070001@nortel.com> <alpine.DEB.1.10.0908271257270.17470@gentwo.org> <alpine.LFD.2.00.0908272242500.2888@localhost.localdomain> <4A971C18.7050109@nortel.com> <alpine.LFD.2.00.0908280238290.2888@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0908280238290.2888@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Aug 2009 21:20:26.0778 (UTC) FILETIME=[5CB57FA0:01CA2825]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2009 06:44 PM, Thomas Gleixner wrote:
> On Thu, 27 Aug 2009, Chris Friesen wrote:
>> How would you deal with per-cpu kernel threads (softirqs, etc.) or
>> softirq processing while in the kernel?
> 
> If you have pinned an interrupt to that CPU then you need to process
> the softirq for it as well. If that's the device your very single user
> space thread is talking to then you better want that, if you are not
> interested then simply pin that device irq to some other CPU: no irq
> -> no softirq.

Ah, okay.  For some reason I had thought that the incoming work was
queued up globally and might be handled by any softirq.

Chris
