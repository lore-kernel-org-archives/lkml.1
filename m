Return-Path: <linux-kernel-owner+w=401wt.eu-S1751879AbXBDBgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbXBDBgX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 20:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbXBDBgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 20:36:23 -0500
Received: from homer.mvista.com ([63.81.120.158]:60501 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbXBDBgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 20:36:23 -0500
Message-ID: <45C53841.5000505@mvista.com>
Date: Sat, 03 Feb 2007 15:34:57 -1000
From: akuster <akuster@mvista.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, akuster@mvista.com,
       linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [patch 1/1] PM: Adds remount fs ro at suspend
References: <20070202235132.EDBDF1C448@hermes.mvista.com> <20070203100848.GA28806@infradead.org>
In-Reply-To: <20070203100848.GA28806@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Christoph Hellwig wrote:
> On Fri, Feb 02, 2007 at 01:50:10PM -1000, akuster@mvista.com wrote:
>>
>> This adds the ability for the file system to remounted as read only during a
>> system suspend.  Log the mount points so when the resume occurs, they can be 
>> remounted back to their original states. This is so in an advent of a power
>> failure, we try our best to keep data from being corrupted or lost.
> 
> Can you please explain why this can't be done in userspace?  

I am sure it can.  The idea came from customer inputs, speed is my 
guess. echo mem > /sys/../state seems a whole lot simpler and cleaner 
than having userspace figure out what it mounted and then doing echo mem.

In fact
> all existing suspend solutions seem to be doing fine doing things like
> this in userspace.

I guess I missed that boat. If you don't mind, could you point at one 
solution.

> 
>> +static struct suspremount *suspremount_list;
>> +
< snipped>

>> +void suspend_remount_all_fs_ro(void)
>> +{
>> +	suspremount_list = NULL;
>> +	emergency_remount();
> 
> NACK.  emergency_remount is exactly what it sais and should never ever
> be used for a system that you want to keep on using later on.  

The code "emergency_remount" is almost identical to what we have been 
using. I wanted to reuse existing code rather than dup it.

If you
> look at it's implementation it's not correct and can't serve as more than
> a bandaid for susrq. 

 From our customer experience, we have not gotten an bad feedback on it. 
  It seems to address there needs.

  In fact we should probably just remove it..
> 
>> +EXPORT_SYMBOL(suspend_remount_all_fs_ro);
> 
> And something like this for sure should not be exported.
> 
>> +EXPORT_SYMBOL(resume_remount_fs_rw);
> 
> ditto.
> 

All the code corrects have been address in my upcoming version.

Many thanks for you time and feedback.

Armin
