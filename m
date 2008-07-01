Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbYGAHa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbYGAHa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 03:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbYGAHaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 03:30:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752284AbYGAHaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 03:30:10 -0400
Date: Tue, 1 Jul 2008 00:28:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, kernel-testers@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>, stable@kernel.org
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
Message-Id: <20080701002856.2457a75d.akpm@linux-foundation.org>
In-Reply-To: <20080701072024.GB26601@elte.hu>
References: <200807010148.02135.rjw@sisk.pl>
	<20080701072024.GB26601@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2008 09:20:24 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > Hi,
> > 
> > The appended patch fixes a regression and is considered as 2.6.26 
> > material. Everyone having a box with working suspend to RAM is gently 
> > requested to test it and verify if it doesn't break things.
> > 
> > The patch applies to the current -git.
> 
> The fix is _really_ tempting, but i think it's 2.6.26.1 material at the 
> earliest. I just counted about 8 red flag items in that commit:
> 
>   - "assembly code"
>   - "fresh change"
>   - "suspend/resume"
>   - "real-mode code"
>   - "ACPI"
>   - "SMM"
>   - "CPU erratas"
>   - "boot code"
> 
> I'd say it's probably 90% fine, but it's just too much risk at this 
> stage i think. The regression was only found 2 weeks ago, and the commit 
> that broke it was upstream for 2 months (and was under testing for about 
> 4 months).

Merge it into 2.6.27-rc1 and add Cc: <stable@kernel.org> to the changelog with
a note "needed in 2.6.26.x after a couple of weeks testing in mainline" or
something like that.

I expect 2.6.25.x will be maintained for a while yet too...
