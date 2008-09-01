Return-Path: <linux-kernel-owner+w=401wt.eu-S1752471AbYIAW5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbYIAW5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 18:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbYIAW5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 18:57:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750722AbYIAW5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 18:57:12 -0400
Date: Mon, 1 Sep 2008 15:56:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
In-Reply-To: <alpine.LFD.1.10.0809020033060.3243@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0809011545020.12958@nehalem.linux-foundation.org>
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809011500460.12958@nehalem.linux-foundation.org> <alpine.LFD.1.10.0809020033060.3243@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Sep 2008, Thomas Gleixner wrote:
> > 
> > Umm. Which one. The 32-bit or the 64-bit?
> 
> The 32 bit version.

So then the PIT isn't going to work on that machine. Do you have HPET?

Because if so, the most obvious choice would be to say:

 - on old machines, the PIT is likely more reliable than PM_TIMER

 - on new machines, the HPET is likely more reliable than PIT

and there's actually a fairly obvious place to distinguish between old and 
new: if ti has a HPET, consider it a new one.

But that just means that there's never any reason to use PM_TIMER anyway, 
and the proper patch would probably be to just ignore it. No?

		Linus
