Return-Path: <linux-kernel-owner+w=401wt.eu-S1766867AbXDSQzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766867AbXDSQzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 12:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766876AbXDSQzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 12:55:05 -0400
Received: from msen.com ([148.59.86.2]:60981 "EHLO shell.msen.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766867AbXDSQzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 12:55:03 -0400
X-Popauth-Info: 1177003289
X-Sent-To: linux-kernel@vger.kernel.org
Date: Thu, 19 Apr 2007 12:55:00 -0400 (EDT)
From: Lou Poppler <lwp@mail.msen.com>
X-X-Sender: lwp@shell.msen.com
To: Tomasz Chmielewski <mangoo@wpkg.org>
cc: linux-kernel@vger.kernel.org, 419950@bugs.debian.org
Subject: Re: NETDEV WATCHDOG, tulip, 2.6.18
In-Reply-To: <4627412D.5010504@wpkg.org>
Message-ID: <20070419114641.C61052@shell.msen.com>
References: <4627412D.5010504@wpkg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Milter: Spamilter (Reciever: shell.msen.com; Sender-ip: 148.59.86.2; Sender-helo: shell.msen.com;)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007, Tomasz Chmielewski wrote:

>> I also have recurrent problems with
>> NETDEV WATCHDOG: eth0: transmit timed out

> If you search the list, you'll find several similar reports about the tulip 
> driver (NETDEV WATCHDOG: eth0: transmit timed out).
>
> Adding nopaic/nolapic/noacpi options to the kernel command line helped in my 
> case.

Yes, I've looked at many similar complaints on this list and on Debian's
BTS, going back several years.  It seems that it happens with more drivers
than just tulip, all with basicly the same symptoms.  The pattern seems to
be: (1) a period of problem-free operation, minutes to days duration;
(2) something bad happens, probably APIC or APCI related, probably
interfering with seeing an interrupt; (3) the kernel doesn't ever
completely recover from the bad event, and the affected interface
remains crippled until reboot.

I will continue to experiment with noapic,nolapic,acpi=off,pci=routeirq
plus variations of BIOS setup options.  This is slow experimentation,
since it can take days to see the problem -- but luckily this machine
is not critical to anything now, and I don't mind taking some time
to try to figure this out.  When I find some settings that avoid the
problem, I think this will mean we have avoided the "something bad"
in step (2) above, possibly by disabling some functionality of the
hardware.  The possibility remains that some part of the kernel could
be coping better with whatever this is, and recovering the normal
operation of the interface after the "something bad".  I think I
remember other peoples' NETDEV WATCHDOG trouble reports where they
say their setup used to work OK under some earlier 2.4 (or 2.2 ?)
kernels, or even under other OSes.

Any other suggestions for boot options I should try are welcome,
as are any requests for other specific info about this system
while it is still in failure mode.
