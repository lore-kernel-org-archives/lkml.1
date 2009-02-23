Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbZBWR3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbZBWR3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 12:29:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbZBWR3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 12:29:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751557AbZBWR3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 12:29:39 -0500
Date: Mon, 23 Feb 2009 09:28:02 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during
 suspend-resume
In-Reply-To: <20090223171630.GA28651@elte.hu>
Message-ID: <alpine.LFD.2.00.0902230926030.3111@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl> <200902230048.33635.rjw@sisk.pl> <20090223083645.GA9582@elte.hu> <200902231229.58743.rjw@sisk.pl> <20090223171630.GA28651@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 23 Feb 2009, Ingo Molnar wrote:
> 
> Linus, do you have a strong opinion about which variant we 
> should use?

Strong? No. I think mine is better just because _if_ another CPU is busy 
handling an interrupt that we're just now disabling, we'll just go on to 
the next interrupt. Waiting for them all at the end is always more 
efficient.

But does it really matter? No. In this case I think we've shut down all 
other CPU's anyway, so the whole "serialize_irq()" should probably not 
even be needed. 

		Linus
