Return-Path: <linux-kernel-owner+w=401wt.eu-S1753481AbZLAPcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbZLAPcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 10:32:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbZLAPcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 10:32:10 -0500
Received: from mx2.compro.net ([12.186.155.4]:46451 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbZLAPcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 10:32:09 -0500
X-Greylist: delayed 846 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Dec 2009 10:32:09 EST
X-IronPort-AV: E=Sophos;i="4.47,321,1257138000"; 
   d="scan'208";a="4729507"
Message-ID: <4B1533B0.1030007@compro.net>
Date: Tue, 01 Dec 2009 10:18:08 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: Mai Daftedar <mai.daftedar@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Signal from kernel space to user space
References: <2cd4ff050912010307h5570a376xc220a95947775eae@mail.gmail.com> <4B151A86.1060505@ladisch.de>
In-Reply-To: <4B151A86.1060505@ladisch.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clemens Ladisch wrote:
> Mai Daftedar wrote:
>>    Im still new to the kernel development world :)and  I was wondering
>> what functions I can use in the kernel space for a signal to be sent
>> to the userspace
> 

I have some interest in this. Might I inject a couple of probably stupid related questions?

> kill_pid_(info) is to be preferred over send_sig_info because it ensures
> that the destination process has the same identity (a plain pid number
> might have wrappend around and be in use by another process).
> 

Does that mean I can't assume my process pid will unique for the life of the process?

> However, why are you using a signal? What information are you trying to
> send, and why wouldn't eventfd or a plain device thaz becomes readable
> be a better solution?
> 

If no "information" is required, which of these are the fastest, say from an interrupt handler?
I have a PCI card that handles external interrupts from the outside world and does nothing but
report those external interrupts to userland. We use send_sig or wake_up_process depending
on whether userland is going to wait for it or not. If there is a better/faster way I would be
very interested.


Thanks and sorry for butting in
Mark

