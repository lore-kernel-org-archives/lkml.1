Return-Path: <linux-kernel-owner+w=401wt.eu-S1760229AbYGaWO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760229AbYGaWO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 18:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758672AbYGaWNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 18:13:10 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:46463 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759954AbYGaWNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 18:13:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=h7LmpeCgvBf5CM2mBmkKWJyWYqptDV2/mYYzgGIceCFitbvFcQaFavCdYFJHDznmHxaOzKiesthe2q+8WWyj4hGmQSJq9dF9K7SSCPMvOSt4LFju+PQa1DE33UALdahB;
Message-ID: <489238E9.6080602@simon.arlott.org.uk>
Date: Thu, 31 Jul 2008 23:12:57 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, Daniel Walker <dwalker@mvista.com>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [patch 5/3] fastboot: sync the async execution before late_initcall
 and move level 6s (sync) first
References: <Pine.LNX.4.44L0.0807311110300.4409-100000@iolanthe.rowland.org> <48920481.7010702@simon.arlott.org.uk> <20080731215601.GC4817@kroah.com>
In-Reply-To: <20080731215601.GC4817@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/08 22:56, Greg KH wrote:
> On Thu, Jul 31, 2008 at 07:29:21PM +0100, Simon Arlott wrote:
>>>> There is nothing else to run between 1-2 and 3, so there is no 
>>>> opportunity
>>>> to initialise devices in the background and usblp_init blocks for a 
>>>> while.
>>> If it were a module then it would block in a separate thread and wouldn't 
>>> hold up the main init process.
>>
>> Right, but I want to compile all of this into the kernel.
> 
> Why?  It sounds like a trivial solution for you is to actually use
> modules.  Why go through a lot of extra work to solve something in a
> different way that is already solved for you?

Because it looks like doing HCD init early enough is a simple way to 
speed up boot time if there are any compiled-in usb device drivers, 
without running the HCD init itself from a separate thread.

Arjan, are you able to test this?
I'll try doing what I've suggested later tonight if I have time.

> Who is imposing the "no modules allowed" rule on you, and why was it
> made?

No one is imposing anything on me. I don't yet have an USB keyboard 
so I could compile all the drivers as modules without any problems.

There's some strange animosity to compiling things that one knows will 
always be needed into the kernel... like the V4L DVB code that used 
to fail to work properly, perhaps because everyone uses modules 
(4abdcf933f647763592db6bef001d1fae61a5527).

It also leads to people unloading/loading the module to workaround 
bugs that could otherwise be fixed 
(c278850206fd9df0bb62a72ca0b277fe20c5a452).

-- 
Simon Arlott
