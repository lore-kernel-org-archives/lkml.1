Return-Path: <linux-kernel-owner+w=401wt.eu-S1161105AbXECIBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161105AbXECIBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 04:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161495AbXECIBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 04:01:51 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2897 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161105AbXECIBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 04:01:50 -0400
Date: Thu, 3 May 2007 09:01:42 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Glen Turner <gdt@gdt.id.au>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Detecting process death for anycast named process monitoring
Message-ID: <20070503080142.GB12018@flint.arm.linux.org.uk>
Mail-Followup-To: Glen Turner <gdt@gdt.id.au>,
	Linux kernel <linux-kernel@vger.kernel.org>
References: <4638FCEA.4010806@gdt.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4638FCEA.4010806@gdt.id.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 06:34:42AM +0930, Glen Turner wrote:
> We don't want to be the parent of the running process, because that
> doesn't add robustness. If the parent process dies, then the service
> dies, and the interface still stays up.

Okay.

> We don't want to poll, because that isn't pretty and the polling
> interval needs to be very short on a big ISP's DNS servers.

If you did have a process which polls for the service, what happens if
that process dies?

> I have tried using the various notify functions against /proc, but
> they don't work for that filesystem. I have tried using notify
> against a UNIX domain socket, but notify doesn't work for
> that either.
> 
> Suggestions, or a patch to support notify for /proc or to push
> process death notifications into DBUS or whatever, are welcome.

What if the dbus system dies?  What if your monitoring process dies?

Surely a simple solution is going to be the best solution?  Given that
you're always going to have another process (which might be killed)
your thought about having a parent process monitor the death of the
child seems to be the simplest.

You could also have that process interact with a watchog, so failures
with that process cause a reboot.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
