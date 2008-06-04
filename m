Return-Path: <linux-kernel-owner+w=401wt.eu-S1758840AbYFDNm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840AbYFDNm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 09:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbYFDNmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 09:42:49 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:12049
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbYFDNms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 09:42:48 -0400
Message-ID: <48469BDA.3050206@qumranet.com>
Date: Wed, 04 Jun 2008 16:42:50 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm@vger.kernel.org>,
       "Anthony N. Liguori [imap]" <aliguori@us.ibm.com>
Subject: Re: kvm causing memory corruption?  now 2.6.26-rc4
References: <1206479576.7562.21.camel@nimitz.home.sr71.net>	 <47EA1C63.8010202@qumranet.com>	 <1206550329.7883.5.camel@nimitz.home.sr71.net>	 <47EA80AC.4070204@qumranet.com>	 <1206551794.7883.7.camel@nimitz.home.sr71.net>	 <47EB6AAC.3040607@qumranet.com>  <47EB7281.6070300@qumranet.com>	 <1206629709.7883.30.camel@nimitz.home.sr71.net>	 <47EBB63E.2060306@qumranet.com> <1212445810.8211.9.camel@nimitz.home.sr71.net>
In-Reply-To: <1212445810.8211.9.camel@nimitz.home.sr71.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (firebolt.argo.co.il [0.0.0.0]); Wed, 04 Jun 2008 16:42:50 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Thu, 2008-03-27 at 16:59 +0200, Avi Kivity wrote:
>   
>> Dave Hansen wrote:
>>     
>>> On Thu, 2008-03-27 at 12:10 +0200, Avi Kivity wrote:
>>>       
>>>> btw, is this with >= 4GB RAM on the host?
>>>>         
>>> Well, are you asking whether I have PAE on or not? :)  
>>>       
>> No, I'm asking whether there is a possibility of address truncation :)
>>
>> PAE by itself doesn't affect kvm much, as it always runs the guest in 
>> pae mode.
>>
>> Can you try running with mem=2000M or something?
>>     
>
> I have a few more data points on this.  Sorry for the massive delay from
> the last report -- I'm being a crappy bug reporter.  But, this is on my
> one and only laptop which makes it a serious pain to diagnose.  I also
> didn't have a hardware serial console on it before, which I do now.
> This is all on 2.6.26-rc4-01549-g1beee8d.
>
> Adding the mem= does not help at all.  But, it is all a bit more
> diagnosable now than a month or two ago.  I turned on all of the kernel
> debugging that I could get my grubby little hands on.  It now oopses
> quite consistently when kvm runs instead of after.  Here's a collection
> of oopses that I captured after setting up a serial line:
>
> 	http://sr71.net/~dave/kvm-oops1.txt
>
> After collecting all those, I turned on CONFIG_DEBUG_HIGHMEM and the
> oopses miraculously stopped.  But, the guest hung (for at least 5
> minutes or so) during windows bootup, pegging my host CPU.  Most of the
> CPU was going to klogd, so I checked dmesg.
>
>   

Can you check with mem=900 (and CONFIG_HIGHMEM_DEBUG=n)?  That will 
confirm that the problems are highmem related, but not physical address 
truncation related.

> I was seeing messages like this
>
> [  428.918108] kvm_handle_exit: unexpected, valid vectoring info and exit reason is 0x9
>
> And quite a few of them, like 100,000/sec.  That's why klogd was pegging
> the CPU.  Any idea on a next debugging step?
>
>   

That's a task switch.  Newer kvms handle them.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

