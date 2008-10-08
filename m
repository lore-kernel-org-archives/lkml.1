Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbYJHMeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbYJHMeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 08:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbYJHMd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 08:33:57 -0400
Received: from venus.billgatliff.com ([209.251.101.201]:60509 "EHLO
	venus.billgatliff.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143AbYJHMd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 08:33:56 -0400
X-Greylist: delayed 1973 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Oct 2008 08:33:56 EDT
Message-ID: <48ECA101.8010604@billgatliff.com>
Date: Wed, 08 Oct 2008 07:01:05 -0500
From: Bill Gatliff <bgat@billgatliff.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: ARM Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Toggling GPIO at 38Khz
References: <9e4733910810072043m6c69f3bdv104bd32928fe64ae@mail.gmail.com>
In-Reply-To: <9e4733910810072043m6c69f3bdv104bd32928fe64ae@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Smirl wrote:

> 
> Are there other techniques for generating pulse trains in the 36-56Khz
> range on a simple GPIO pin?
> 

Yes.

Use the GPIO pin to enable the output of an external circuit.  Or, hope that the
GPIO pin in question is multiplexed with a timer/counter or PWM peripheral.

But somehow, I don't think either answer is what you were looking for.  :)

36 KHz bit-banging is a reach for any processor running Linux, methinks.  Maybe
you could launch an FIQ (assuming ARM) and then do the bit-bang as a burst in
there, so that you would have more control over the timing.  But that kind of
code isn't going to play well with the rest of the kernel...

If the hardware design isn't set, you might want to consider using that GPIO
line as a quasi-SPI link to a small, AVR-type microcontroller that does the
bit-banging on your behalf.  Long-term, that's going to be a more reliable and
flexible solution I think.


b.g.
-- 
Bill Gatliff
bgat@billgatliff.com
