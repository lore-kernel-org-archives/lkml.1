Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbZKTSzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbZKTSzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 13:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753760AbZKTSzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 13:55:42 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:5470 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbZKTSzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 13:55:42 -0500
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Nov 2009 13:55:42 EST
X-Spam-Processed: digidescorp.com, Fri, 20 Nov 2009 12:49:17 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1575b24108=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RESEND] microblaze: Fix level interrupt ACKing
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: monstr@monstr.eu
Cc: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
In-Reply-To: <4B067868.9070902@monstr.eu>
References: <1258469019-3863-1-git-send-email-steve@digidescorp.com>
	 <4B067868.9070902@monstr.eu>
Content-Type: text/plain
Organization: Digital Design Corporation
Date: Fri, 20 Nov 2009 12:49:16 -0600
Message-Id: <1258742956.2881.3.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-20 at 12:07 +0100, Michal Simek wrote:
> Hi Steve,
> 
> steve@digidescorp.com wrote:
> > Level interrupts need to be ack'd in the unmask handler, as in powerpc. 
> > Among other issues, this bug causes the system clock to appear to run at 
> > double-speed.
> 
> Can you send me any step-by-step manual how to demonstrate me this 
> fault? If system clock runs at double-speed, then I should be able able 
> to see that time is two times faster. Or do you mean different behavior?

Unless there's a way to read jiffies_64 in userspace, the easiest way I
know of is to use the debugger. Stop the kernel soon after you boot it,
and read jiffies_64. Continue execution for some known amount of
wall-clock time, then stop the kernel again and recheck jiffies_64.
Without the patch, the number of elapsed jiffies is twice what you'd
expect based on HZ.

> 
> Thanks,
> Michal

Regards,
------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>



