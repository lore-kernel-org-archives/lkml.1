Return-Path: <linux-kernel-owner+w=401wt.eu-S1761822AbXH3OuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761822AbXH3OuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 10:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757708AbXH3Otx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 10:49:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60648 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbXH3Otw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 10:49:52 -0400
Message-ID: <46D6D8F6.2040201@zytor.com>
Date: Thu, 30 Aug 2007 07:49:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Christian Ehrhardt <lk@c--e.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: New x886-Setup code breaks HVM-XEN boot
References: <20070830141528.GA307@lisa.in-ulm.de>
In-Reply-To: <20070830141528.GA307@lisa.in-ulm.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Ehrhardt wrote:
> 
> Note the the xm console command terminates on its own, i.e. the guest
> machine seems to halt and not hang somewhere.
> 
> I could verify that the real mode code up to the assembly code in
> pmjump.S is in fact executed. The problem appears to occur while
> enabling protected mode. I tried to put endless loops into the 32-bit
> setup code but these were apparently not reached. As far as I understand
> this, the protected mode jump in pmjump.S seems to jump into nowhere.
> 
> I am willing to do tests with the XEN guest and send any additional
> information that might be helpful. However, I cannot change the XEN host
> at this time.
> 
> Any suggestions? 
> 

All of this point to a bug in the Xen emulation host.  You're not saying 
  if you're on an Intel or AMD host, but on Intel, hardware 
virtualization doesn't actually kick in until you're in protected mode 
with all segments configured properly.  This means all of pmjump.S runs 
in an interpreter.  A bug in that interpreter would cause what you observe.

	-hpa
