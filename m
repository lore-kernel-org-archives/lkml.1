Return-Path: <linux-kernel-owner+w=401wt.eu-S1765866AbXGUTkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765866AbXGUTkj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 15:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758488AbXGUTk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 15:40:29 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:21610 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756299AbXGUTk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 15:40:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=QSZ6eF+2ua8zUWbBpuRHBsDUt6OFU3G2I7jV3yX84Gk9fUZPBdPAFgMdVw4Yl2xCFPDoUKwEgTXQ/JNM5RXW6nOpX1R3aH2glQcVSUDaczpKiOcj1MEZddEzxmQUfza5VlF90Mte2Myrdbr3dNR8xqWD2pKlfySYyA7llDHRKgM=  ;
X-YMail-OSG: czNXc04VM1mkV2nwwrzJx4166ven3LJiB7LX.t7ZYazo9su_6L_RAS6hP7Ci6DiQzRGBqAnK6g--
From: David Brownell <david-b@pacbell.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Resend][PATCH 1/9] ACPI: Implement the set_target() callback from pm_ops
Date: Sat, 21 Jul 2007 12:26:30 -0700
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <len.brown@intel.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Shaohua Li <shaohua.li@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Paul Mackerras <paulus@samba.org>, Russell King <rmk@arm.linux.org.uk>
References: <200707172236.28895.rjw@sisk.pl> <200707172240.08494.rjw@sisk.pl>
In-Reply-To: <200707172240.08494.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200707211226.31118.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 July 2007, Rafael J. Wysocki wrote:
> In the future some drivers may need to use ACPI to determine the low power
> states in which to place their devices, but to provide the drivers with this
> information the ACPI core needs to know what sleep state the system is going to
> enter.  Namely, the device's state should not be too high power for given system
> sleep state and, if the device is supposed to be able to wake up the system, its
> state should not be too low power for the wake up to be possible).  For this
> purpose, the ACPI core needs to implement the set_target() method in 'struct
> pm_ops' and store the target system sleep state passed by the PM core in a
> variable.

Modulo Len's "please remove non-existent S2 state", ACK.

We still have a general issue that most platforms implement
at most one of the sleep states the hardware allows (plus,
sometimes, hibernation).

A key differentiator of those different sleep states is usually
that they have characteristics which allow various devices to
work, or not.  Like, oh, USB controllers which need a 48 MHz
oscillator to process wakeup events ... but the deepest sleep
states must disable that oscillator.

So it's a Good Thing that this patch (and #2) expose that more
complete model of system sleep states to drivers running on x86.

- Dave
