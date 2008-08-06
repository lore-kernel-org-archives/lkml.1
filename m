Return-Path: <linux-kernel-owner+w=401wt.eu-S1760263AbYHFTWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760263AbYHFTWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 15:22:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756686AbYHFTUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 15:20:18 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:55249 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681AbYHFTUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 15:20:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=G2PxcnZmp3XAmuGb8qPgKLoO9Vq7Q3/+Os3aSaRqds36EEiQgFcfm6pZ+uVhWK6pkBSGOr6W/LwG4BzbsmXH98rrOqMrUv+3TyrnfoZ6CExY0/eej/xFoPR9OFRRcXpU;
Message-ID: <4899F96D.9060809@simon.arlott.org.uk>
Date: Wed, 06 Aug 2008 20:20:13 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Rene Herman <rene.herman@keyaccess.nl>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, Daniel Walker <dwalker@mvista.com>,
       USB list <linux-usb@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH RFC] USB: Add HCD fastboot
References: <Pine.LNX.4.44L0.0808061508430.12900-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808061508430.12900-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/08 20:11, Alan Stern wrote:
> On Wed, 6 Aug 2008, Simon Arlott wrote:
> 
>> On 31/07/08 20:16, Alan Stern wrote:
>> >> > It's not entirely clear why usblp is blocking at all.  Probably because
>> >> > it is waiting on the device semaphores for devices that are currently
>> >> > being probed -- the driver core won't allow two threads to probe the
>> >> > same device concurrently.
>> >> 
>> >> Ok - so there could be some big improvements to be had by making the hcd 
>> >> init happen as early as possible and the device initcalls later?
>> > 
>> > Maybe.  Perhaps a better approach would be to make the device driver 
>> > initcalls before there are any devices for their probe routines to 
>> > block on.
>> 
>> What about this?
>> 
>> The Makefiles become a bit messy, but by moving things around I get the 
>> desired effect without splitting their initcalls.
> 
> Wouldn't it be much simpler, and less objectionable, to do what I
> suggested earlier?  That is, add a 5-second delay at the start of
> hub_thread() in drivers/usb/core/hub.c.  No messing with Makefiles, no
> changes to the initcall scheduling.

Aside from 5 seconds being too long, and anything less being a race between 
hub_thread() and driver initcalls, it doesn't improve anything because it'll 
still have to wait for the devices to finish initialising in userspace instead.

-- 
Simon Arlott
