Return-Path: <linux-kernel-owner+w=401wt.eu-S939261AbXHIREV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939261AbXHIREV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 13:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765497AbXHIREL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 13:04:11 -0400
Received: from mailhub.lawrence.edu ([143.44.0.14]:42542 "EHLO lawrence.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762285AbXHIREJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 13:04:09 -0400
Message-ID: <46BB47C9.3030609@gmail.com>
Date: Thu, 09 Aug 2007 12:58:49 -0400
From: Dan Zwell <dzwell@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Tino Keitel <tino.keitel@gmx.de>, David Brownell <david-b@pacbell.net>,
       linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 2.6.23-rc1: USB hard disk broken
References: <20070725072343.GA3483@dose.home.local> <200707261006.41368.oliver@neukum.org> <20070805110942.GA26278@dose.home.local> <200708051746.32439.oliver@neukum.org>
In-Reply-To: <200708051746.32439.oliver@neukum.org>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver Neukum wrote:
> Am Sonntag 05 August 2007 schrieb Tino Keitel:
>> On Thu, Jul 26, 2007 at 10:06:40 +0200, Oliver Neukum wrote:
>>> Am Mittwoch 25 Juli 2007 schrieb Tino Keitel:
>>>> On Wed, Jul 25, 2007 at 10:24:36 +0200, Oliver Neukum wrote:
>>>>> Am Mittwoch 25 Juli 2007 schrieb Tino Keitel:
>>>>>> Hi,
>>>>>>
>>>>>> I just tried 2.6.23-rc1 and shortly after the boot my external USB hard
>>>>>> disk went mad.
>>>> [...]
>>>>
>>>>> Please recompile with CONFIG_USB_DEBUG set.
>>>>>
>> I tried again -rc1 without USB_DEBUG, and was able to reproduce the
>> bug 2 times. At the second time, the kernel log shows this:
>>
>> 2007-08-05_10:30:27.75572 kern.err: ehci_hcd 0000:00:1d.7: dev 6 ep1in scatterli
>> st error 0/-121
>> 2007-08-05_10:30:27.86576 kern.info: usb 1-6: reset high speed USB device using ehci_hcd and address 5
>> 2007-08-05_10:30:55.95293 kern.info: usb 1-6: USB disconnect, address 5
>> 2007-08-05_10:30:55.95300 kern.err: ehci_hcd 0000:00:1d.7: dev 6 ep1in scatterlist error -108/-108
> 
> David, does this error say anything to you?
> 
> 	Regards
> 		Oliver

Hi,

I just completed a git bisect, and commit 
8dfe4b14869fd185ca25ee88b02ada58a3005eaf was the commit that introduced 
this problem. This is "usb-storage: implement autosuspend". I don't 
think there have been many changes in drivers/usb since I last verified 
this problem, so I'm pretty sure this is still happening in the latest 
kernel.

The first thing I am going to do is pull the latest sources, attempt to 
revert this patch, and see whether the kernel compiles and works 
properly with my USB hard drive. Please let me know of anything I can do 
to help.

Dan
