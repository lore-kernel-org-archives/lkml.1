Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbZCKWHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbZCKWHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 18:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbZCKWG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 18:06:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754024AbZCKWG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 18:06:58 -0400
Date: Wed, 11 Mar 2009 15:01:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Frans Pop <elendil@planet.nl>,
       =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [PATCH 1/10] PM: Rework handling of interrupts during suspend-resume
 (rev. 5)
In-Reply-To: <alpine.LFD.2.00.0903112251150.29264@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0903111459210.32478@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl> <200903112215.02445.rjw@sisk.pl> <alpine.LFD.2.00.0903112234530.29264@localhost.localdomain> <200903112250.10572.rjw@sisk.pl> <alpine.LFD.2.00.0903112251150.29264@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Mar 2009, Thomas Gleixner wrote:
> 
> I'm not worried about nested ones.

Then you shouldn't be worried about IRQ_SUSPENDED at all, since that one 
increments the disabled depth count.

So _all_ disable/enable_irq calls will by definition be nested inside 
IRQ_SUSPENDED. 

		Linus
