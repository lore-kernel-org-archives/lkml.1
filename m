Return-Path: <linux-kernel-owner+w=401wt.eu-S932812AbXBTC4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbXBTC4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 21:56:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932815AbXBTC4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 21:56:34 -0500
Received: from terminus.zytor.com ([192.83.249.54]:37787 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932812AbXBTC4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 21:56:33 -0500
Message-ID: <45DA6354.3000305@zytor.com>
Date: Mon, 19 Feb 2007 18:56:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Rodolfo Giometti <giometti@enneenne.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
References: <20070216185230.GO8882@enneenne.com>
In-Reply-To: <20070216185230.GO8882@enneenne.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rodolfo Giometti wrote:
> 
> Please read the following consideratios before sending to /dev/null!
> :)
> 
> RFC considerations
> ------------------
> 
> While implementing a PPS API as RFC 2783 defines and using an embedded
> CPU GPIO-Pin as physical link to the signal, I encountered a deeper
> problem:
> 
>    At startup it needs a file descriptor as argument for the function
>    time_pps_create().
> 
> This implies that the source has a /dev/... entry. This assumption is
> ok for the serial and parallel port, where you can do something
> usefull beside(!) the gathering of timestamps as it is the central
> task for a PPS-API. But this assumption does not work for a single
> purpose GPIO line. In this case even basic file-related functionality
> (like read() and write()) makes no sense at all and should not be a
> precondition for the use of a PPS-API.
> 

It's not a precondition for a file descriptor, either.  There are plenty 
of ioctl-only device drivers in existence.

Furthermore, a file descriptor doesn't imply a device entry.  Consider 
pipe(2), for example.

As far as the kernel is concerned, a file handle is a nice, uniform 
system for providing communication between the kernel and user space. 
It doesn't matter if one can read() or write() on it; it's perfectly 
normal to support only a subset of the normal operations.

	-hpa
