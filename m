Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbYFZGiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbYFZGiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 02:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbYFZGip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 02:38:45 -0400
Received: from smtp.nokia.com ([192.100.122.233]:55128 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbYFZGio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 02:38:44 -0400
Message-ID: <486337D4.1000904@nokia.com>
Date: Thu, 26 Jun 2008 09:31:48 +0300
From: Stefan Becker <Stefan.Becker@nokia.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: ext Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [REGRESSION] 2.6.24/25: random lockups when accessing external
 USB harddrive
References: <Pine.LNX.4.44L0.0806251408300.3394-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0806251408300.3394-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jun 2008 06:31:49.0027 (UTC) FILETIME=[500D5730:01C8D756]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

ext Alan Stern wrote:
> On Wed, 25 Jun 2008, Stefan Becker wrote:
> 
>> HCD URB list locked by usb_hcd_link_urb_to_ep!
>>
>> As far as I understand the matter this only can happen if 
>> usb_hcd_link_urb_to_ep() gets interrupted while holding the spinlock. 
>> But according to the contract at the header of the function it should be 
>> called with interrupts disabled!
> 
> So it should.  Do you know how to test whether interrupts are enabled?  
> There's a routine called raw_irqs_disabled() defined in 
> include/asm/irqflags.h.  Stick it inside usb_hcd_link_urb_to_ep, and 
> the first time it returns nonzero, do a dump_stack().

Tried both and got nothing. So either our reasoning is wrong or 
something really weird is going on. I'll try to improve my debugging 
code and use dump_stack() at the place where it locks up.

Regards,

	Stefan

---
Stefan Becker
E-Mail: Stefan.Becker@nokia.com
