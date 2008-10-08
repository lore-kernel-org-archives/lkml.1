Return-Path: <linux-kernel-owner+w=401wt.eu-S1754946AbYJHRAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbYJHRAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 13:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbYJHRAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 13:00:22 -0400
Received: from zrtps0kn.nortel.com ([47.140.192.55]:44505 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbYJHRAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 13:00:21 -0400
Message-ID: <48ECE71B.6030405@nortel.com>
Date: Wed, 08 Oct 2008 11:00:11 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Bill Gatliff <bgat@billgatliff.com>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Toggling GPIO at 38Khz
References: <9e4733910810072043m6c69f3bdv104bd32928fe64ae@mail.gmail.com> <48ECA101.8010604@billgatliff.com> <9e4733910810080606ne8bdbb8v81d42069c985ae98@mail.gmail.com>
In-Reply-To: <9e4733910810080606ne8bdbb8v81d42069c985ae98@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Oct 2008 17:00:15.0916 (UTC) FILETIME=[5611FEC0:01C92967]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Smirl wrote:

> The existing LIRC driver for a serial port is here:
> http://lirc.cvs.sourceforge.net/viewvc/lirc/lirc/drivers/lirc_serial/lirc_serial.c?view=markup

That driver basically does busy-wait bitbanging, using rdtsc on x86 if 
available or udelay() if not.

Your best bet is probably to use hrtimers combined with high res 
timestamps to correct for accumulated error.

Chris
