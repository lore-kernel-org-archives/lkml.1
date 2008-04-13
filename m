Return-Path: <linux-kernel-owner+w=401wt.eu-S1752750AbYDMR7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbYDMR7Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 13:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbYDMR7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 13:59:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51226 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbYDMR7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 13:59:00 -0400
Date: Sun, 13 Apr 2008 10:53:48 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Yinghai Lu <yinghai.lu@sun.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [rfc] hw resource debugging checks
Message-ID: <20080413105348.22e55ea5@laptopd505.fenrus.org>
In-Reply-To: <87d4ouw0u9.fsf@basil.nowhere.org>
References: <200804102159.14563.rjw@sisk.pl>
	<20080410203800.GA14560@elte.hu>
	<200804110028.22290.rjw@sisk.pl>
	<200804112126.29455.rjw@sisk.pl>
	<20080413075845.GJ20332@elte.hu>
	<87d4ouw0u9.fsf@basil.nowhere.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Apr 2008 11:39:10 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
> This whole problem just shows that it was a mistake in the first place
> to try to redo the BIOS work in Linux. If BIOS doesn't supply MCFG
> Linux trying to create one (or in general having generalized resource
> allocation) is just a big mess and will cause endless problems.  The
> standard resource code is just not up to the task and it needs very
> intimate knowledge of the hardware that the kernel shouldn't have.
> 
> Again the real fix I think is to just drop all that code in git-x86
> again and finally fix LinuxBIOS to do its job properly and pass a
> proper MCFG (or just forget about using mmconfig with LinuxBIOS - it
> is not that Type1 suddently doesn't work anymore). Then this code
> wouldn't be needed at all

I totally agree with this. MCFG has been EXTREMELY fragile for the last years,
and I don't see that changing anytime soon.
The only thing that works for Linux so far is "if it even smells funny, don't use it".
Smelling funny is things like
1a) Bios table and e820 not matching up, or
1b) Bios table and hardware data not matching up
2) The content not matching content gotten via the traditional method
3) ... (bunch of other sanity checks)

I guess we really need to have
0) If it's not present in the BIOS do not touch
as rule as well.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
