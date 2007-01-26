Return-Path: <linux-kernel-owner+w=401wt.eu-S1161250AbXAZT5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161250AbXAZT5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 14:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161251AbXAZT5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 14:57:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161250AbXAZT5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 14:57:48 -0500
Message-ID: <45BA5BBE.7060709@redhat.com>
Date: Fri, 26 Jan 2007 14:51:26 -0500
From: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@redhat.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060803)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Pete Zaitcev <zaitcev@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Juju
References: <20070124223745.33278eb4.zaitcev@redhat.com> <45B91EAB.9080004@redhat.com> <20070125153824.8d7f50c5.zaitcev@redhat.com> <20070126064701.GA21892@kroah.com>
In-Reply-To: <20070126064701.GA21892@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Jan 25, 2007 at 03:38:24PM -0800, Pete Zaitcev wrote:
>> On Thu, 25 Jan 2007 16:18:35 -0500, Kristian H??gsberg <krh@redhat.com> wrote:
>>
>>>> I see that ORBs are always allocated with a call (like SKB) and not
>>>> embedded into drivers (like URBs). It's great, keep it up. Also,
>>>> never allow drivers to pass DMA-mapped buffers into fw_send_request
>>>> and friends. We made both of these mistakes in USB, and it hurts.
>>> Oh, the ORBs are SBP-2 specific data structures, struct fw_transaction is 
>>> probably what corresponds to USB URBs.  This struct is defined in 
>>> fw-transaction.h and is available for embedding into other structs, such as 
>>> struct sbp2_orb in fw-sbp2.  Is that what you're suggesting against, and what 
>>> are the problems with this approach?
>> Fortunately we do not care about out-of-tree drivers, which are most
>> affected, you may even call it a feature ^_^. My main problem is,
>> we can't refcount URBs, so usbmon can't tap them and must copy.
> 
> urbs are reference counted, it's just that not all drivers who create
> them use them that way :(
> 
> Perhaps you can inforce this in the new codebase...

It's a small change to make the fw_transaction struct opaque and ref-counted, 
and it's definitely still doable.  But the nice thing about embedding the 
struct is that you have one memory allocation failure path less to worry 
about.  And I haven't yet, and don't expect to see a use case that will need 
ref-counted struct fw_transaction, the ownership is always clearly defined. 
But I can go either way on this and if there is a good reason to ref count 
them it's a pretty small change.

cheers,
Kristian
