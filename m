Return-Path: <linux-kernel-owner+w=401wt.eu-S1758594AbZIQNGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594AbZIQNGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 09:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758464AbZIQNGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 09:06:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758405AbZIQNGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 09:06:22 -0400
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Alan Cox <alan@linux.intel.com>, Amit Shah <amit.shah@redhat.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for generic guest and host communication
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com>
	<1252678386-17404-2-git-send-email-amit.shah@redhat.com>
	<20090911170010.34c80f2d@linux.intel.com>
	<20090911163806.GB25535@amit-x200.redhat.com>
	<4AAA8838.1080106@codemonkey.ws>
	<20090911173307.GB27046@amit-x200.redhat.com>
	<4AAA8A56.3040707@codemonkey.ws>
	<20090916112332.6bf981a5@linux.intel.com>
	<4AB164A0.8000402@codemonkey.ws>
From: Markus Armbruster <armbru@redhat.com>
Date: Thu, 17 Sep 2009 15:06:20 +0200
In-Reply-To: <4AB164A0.8000402@codemonkey.ws> (Anthony Liguori's message of "Wed\, 16 Sep 2009 17\:20\:16 -0500")
Message-ID: <87tyz1en5f.fsf@pike.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori <anthony@codemonkey.ws> writes:

> Alan Cox wrote:
>>> This device is very much a serial port.  I don't see any reason not
>>> to treat it like one.
>>>     
>>
>> Here are a few
>>
>> - You don't need POSIX multi-open semantics, hangup and the like
>>   
>
> We do actually want hangup and a few other of the tty specific ops.  The 
> only thing we really don't want is a baud rate.

And a line discipline, and messing with the controlling terminal, and
group/session ID, and window size, and software flow control, ...

>> - Seek makes sense on some kinds of fixed attributes
>>   
>
> I don't think we're dealing with fixed attributes.  These are streams.  
> Fundamentally, this is a paravirtual uart.  The improvement over a 
> standard uart is that there can be a larger number of ports, ports can 
> have some identification associated with them, and we are not 
> constrained to the emulated hardware interface which doesn't exist on 
> certain platforms (like s390).
[...]

Well, really fundamentally, this is just a reliable full-duplex byte
stream, with connect and hangup notification.  To me, that sounds more
like TCP with an address family almost, but not quite AF_UNIX, but that
case was thrown out of court long ago, so here we are.
