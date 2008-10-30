Return-Path: <linux-kernel-owner+w=401wt.eu-S1756967AbYJ3VH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbYJ3VH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbYJ3VHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:07:14 -0400
Received: from hs-out-0708.google.com ([64.233.178.244]:8423 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbYJ3VHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:07:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=G44bR3xW6KcWrZLA3y1Q66uJz6rCDcQRx6uHxK3PmbtKmbtUjU5g2S1sneU6izJZOJ
         GlichEEQG+SFw4tb8fR9TIr6FAxetsKLxlLgJyVyMzOmEuoQVXVGgnDZWvM+L3rdQgpk
         36IVNRCKpuz4i+i69PlkYBenBEE6DYgneiDJc=
Date: Thu, 30 Oct 2008 17:05:22 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: 2.6.28-rc1: NVRAM being corrupted on ppc64 preventing boot
	(bisected)
Message-ID: <20081030210522.GA6532@yoda.jdub.homelinux.org>
References: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org> <20081030142632.GA15645@csn.ul.ie> <18698.7794.500191.189515@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18698.7794.500191.189515@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 07:52:02AM +1100, Paul Mackerras wrote:
>Mel Gorman writes:
>
>> On some ppc64 machines, NVRAM is being corrupted very early in boot (before
>> console is initialised). The machine reboots and then fails to find yaboot
>> printing the error "PReP-BOOT: Unable to load PRep image".  It's nowhere near
>> as serious as the ftrace+e1000 problem as the machine is not bricked but it's
>> fairly scary looking, the machine cannot boot and the fix is non-obvious. To
>> "fix" the machine;
>> 
>> 1. Go to OpenFirmware prompt
>> 2. type dev nvram
>> 3. type wipe-nvram
>> 
>> The machine will reboot, reconstruct the NVRAM using some magic and yaboot
>> work again allowing an older kernel to be used. I bisected the problem down
>> to this commit.
>
>Eek!
>
>Which ppc64 machines has this been seen on, and how were they being
>booted (netboot, yaboot, etc.)?
>
>Is it just the Powerstations with their SLOF-based firmware, or is it
>IBM pSeries machines as well?

I'm pretty sure it was with pSeries machines.  I saw reports of POWER5
being effected (p520 and p710).  I believe one of them resolved the
issue by upgrading firmware on the machine.

josh
