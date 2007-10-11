Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbXJKLgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbXJKLgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 07:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbXJKLga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 07:36:30 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:52301 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbXJKLg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 07:36:29 -0400
Date: Thu, 11 Oct 2007 17:05:40 +0530
To: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Subject: Re: gigabit ethernet power consumption
Reply-To: prasad@linux.vnet.ibm.com
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
Organization: IBM
Cc: "Pavel Machek" <pavel@ucw.cz>, "Arjan van de Ven" <arjan@infradead.org>,
       "kernel list" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <20071008220720.GF3484@elf.ucw.cz> <470AAFD7.9060002@intel.com> <20071009182857.GF4003@csclub.uwaterloo.ca> <470BCB4D.8090307@intel.com>
Content-Transfer-Encoding: 7bit
Message-ID: <op.tz06hqzf03j166@localhost.localdomain>
In-Reply-To: <470BCB4D.8090307@intel.com>
User-Agent: Opera Mail/9.23 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Oct 2007 00:11:17 +0530, Kok, Auke <auke-jan.h.kok@intel.com>  
wrote:

> Lennart Sorensen wrote:
>> On Mon, Oct 08, 2007 at 03:31:51PM -0700, Kok, Auke wrote:
>>> you most certainly want to do this in userspace I think.
>>>
>>> One of the biggest problems is that link negotiation can take a  
>>> significant amount
>>> of time, well over several seconds (1 to 3 seconds typical) with  
>>> gigabit, and
>>> having your ethernet connection go offline for 3 seconds may not be  
>>> the desired
>>> effect for when you want to get more bandwidth in the first place.
>>>
>>> However, when a laptop is in battery mode, switching down from gigabit  
>>> to 100mbit
>>> makes a lot more sense, so this is something I would recommend. This  
>>> can be as
>>> easy as changing the advertisement mask of the interface and  
>>> renegotiating the
>>> link. Userspace could handle that very easily.
>>
>> Now if you were trying to transfer a lot of data to the laptop, would it
>> be more power efficient to do it at gigabit speeds so you can finish
>> sooner and shut down the machine entirely, or to slow to 100mbit and
>> take longer to do it, and hence spend more time powering the cpu and
>> ram?
>
> my suspicion is that the cost of switching is much higher than what you  
> would
> consume running at 100mbit, even if the amount of data is quite large.  
> going
> offline to renegotiate the link would already cost you 3W typically.
>
> I definately think that userspace is the right field to solve this  
> problem: let
> the users decide how to use the available power on their sytems through  
> a decent
> power profile tool (perhaps gnome-power-manager or something like that).  
> This way
> the user can choose.
>
> Auke
> -

Perhaps interrupt moderation could be of help here (say - switch to lesser  
interrupts per unit of time when running on battery), which I find that  
the e1000 driver doesn't employ in the kernel presently. (For interrupt  
moderation, refer:  
http://download.intel.com/design/network/applnots/ap450.pdf.)

Without the side-effect of experiencing a link-flap when switching to a  
lower-speed (with its toll in terms of down-time for auto-negotiation,  
STP, etc), the Interrupt Moderation Algorithm dynamically adjusts the  
number of interrupts based on traffic - and presumably consume less power.  
For an "Optimise for Power" kind of profile - the driver can be loaded  
with a higher throttle rate during boot-time.

Thanks,
K.Prasad
