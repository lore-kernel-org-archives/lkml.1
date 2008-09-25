Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbYIYE0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbYIYE0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 00:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbYIYE0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 00:26:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:12658 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbYIYE0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 00:26:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nG7pnZOZnhw/kfeaAMzEiLddZIi6XCMXlZOYeCKi0fJ3GmYMy16TTMfktmYkwxWaaf
         DIoplcpuW1hf4XmGlrHs5q92VwDNpU6YGJb8NxOrS6fR1pph1m0lmjyf5uX5wyDcrDf5
         N2AteiXZZ6AL2ofHQcov636oo8RIRVXNPQu8Q=
Message-ID: <48DB12C9.5080104@gmail.com>
Date: Wed, 24 Sep 2008 21:25:45 -0700
From: Jesse Brandeburg <jesse.brandeburg@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, David Miller <davem@davemloft.net>,
       jeffrey.t.kirsher@intel.com, david.vrabel@csr.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com, Ingo Molnar <mingo@elte.hu>,
       jbarnes@virtuousgeek.org
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
References: <20080923.150722.141587696.davem@davemloft.net>	 <9929d2390809231512w160d221axa2923a6b293a041@mail.gmail.com>	 <alpine.LNX.1.10.0809240014390.4671@pegasus.suse.cz>	 <20080923.211215.193696086.davem@davemloft.net>	 <alpine.LNX.1.10.0809250110070.4671@pegasus.suse.cz> <21d7e9970809241722w7c3bb6a5w1af5801b7380169d@mail.gmail.com>
In-Reply-To: <21d7e9970809241722w7c3bb6a5w1af5801b7380169d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
>>> If the MMIO space regions of the video cards sit right before the
>>> E1000E ones on the effected systems, that would pretty much
>>> convince me that this is the kind of problem we are having here.
>> Unfortunately, looking at the lspci outputs that are in
>> https://bugzilla.novell.com/show_bug.cgi?id=425480 it seems to me that the
>> MMIO regions are quite far away from each other.

on my ich9 based system the e1000e BAR1 regions are back to back with 
both the vga memory map and the audio mem, either of which could be the 
mangler, but more likely vga device (say X maybe) since it is mapped 
directly in front of the e1000e BAR1 space.

> Yup on my laptop these were far away and I wondered what could mangle
> things that badly.
> 
> Well I'm out of the race, my attempts to re-write my eeprom using an
> eeprom from an equivalent laptop
> have totally failed and my BIOS won't boot anymore - so my laptop is == a brick.

I'm really sorry to hear that, I wonder if the laptop has an "emergency 
bios update" mode like many PCs used to through a jumper.  Dave A., let 
us know if you make any recovery progress.

I plan to try some random writes tomorrow to my BAR1 space and see if my 
flash gets erased.

Jesse
