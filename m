Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453Ab0CAV0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 16:26:10 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:5250 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab0CAV0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 16:26:08 -0500
X-Spam-Processed: digidescorp.com, Mon, 01 Mar 2010 15:26:08 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1676f4a1ed=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: [RFC] microblaze: Support FRAME_POINTER for better backtrace
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: Paul Mundt <lethal@linux-sh.org>
Cc: monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100301014300.GA23086@linux-sh.org>
References: <1267128809-22749-1-git-send-email-steve@digidescorp.com>
	 <4B878106.1090007@monstr.eu>
	 <1267202998.3124.75.camel@iscandar.digidescorp.com>
	 <20100301014300.GA23086@linux-sh.org>
Content-Type: text/plain
Organization: Digital Design Corporation
Date: Mon, 01 Mar 2010 15:26:05 -0600
Message-Id: <1267478765.17327.3.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul -

On Mon, 2010-03-01 at 10:43 +0900, Paul Mundt wrote: 
> This doesn't look that bad compared to what some of the other
> architectures have to deal with. If the frame pointer is always setup
> using these addik/swi pairs then you can trivially scan an arbitrary
> number of instructions attempting to match before giving up. We do
> similar things for sh64 where we also have to figure out how stack frames
> were created in order to roll them back.
> 
> In any event, take a look at arch/sh/kernel/cpu/sh5/unwind.c, you should
> be able to use a similar scheme without the need for undue complexity.
> 

Thanks for the tip. This looks manageable. I had thought to search for
instructions that create frames but didn't think working backwards from
return addresses was a good idea. Using kallsyms to get the "top" of
each function is a nice way around that.

Regards,
------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>



