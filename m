Return-Path: <linux-kernel-owner+w=401wt.eu-S1755806AbXD0NJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbXD0NJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 09:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbXD0NJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 09:09:27 -0400
Received: from mta13.mail.adelphia.net ([68.168.78.44]:37405 "EHLO
	mta13.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806AbXD0NJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 09:09:26 -0400
Message-ID: <4631F603.40901@acm.org>
Date: Fri, 27 Apr 2007 08:09:23 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Icedove 1.5.0.10 (X11/20070328)
MIME-Version: 1.0
To: Corey Minyard <minyard@acm.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-serial@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] serial 8250: move push calls out of lock
References: <20070426205103.GA28569@localdomain> <20070426205847.GB11735@flint.arm.linux.org.uk> <46311E48.4070106@acm.org>
In-Reply-To: <46311E48.4070106@acm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Corey Minyard wrote:
> Russell King wrote:    
>>
>> Use of an uninitialised variable.  The reason we use check_modem_status
>> to return the current status here is because reading the MSR _clears_
>> interrupts.  So, repeatedly calling get_mctrl via an ioctl is a great
>> way to introduce a hardware race condition if you just read the MSR and
>> never act on it.
>>   
> "status" is used as a return variable; it is set by the call.  I modified
> check_modem_status() to return if it detected a change and set the
> status if it was passed in.
Ok, I see what I missed.  Never mind.

-corey

