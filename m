Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbYDMJjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbYDMJjc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 05:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754952AbYDMJjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 05:39:23 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:47966 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbYDMJjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 05:39:23 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai Lu <yinghai.lu@sun.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [rfc] hw resource debugging checks
From: Andi Kleen <andi@firstfloor.org>
References: <200804102159.14563.rjw@sisk.pl> <20080410203800.GA14560@elte.hu>
	<200804110028.22290.rjw@sisk.pl> <200804112126.29455.rjw@sisk.pl>
	<20080413075845.GJ20332@elte.hu>
Date: Sun, 13 Apr 2008 11:39:10 +0200
In-Reply-To: <20080413075845.GJ20332@elte.hu> (Ingo Molnar's message of "Sun, 13 Apr 2008 09:58:45 +0200")
Message-ID: <87d4ouw0u9.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Apr 2008 09:32:25.0736 (UTC) FILETIME=[48AA6880:01C89D49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

This whole problem just shows that it was a mistake in the first place
to try to redo the BIOS work in Linux. If BIOS doesn't supply MCFG
Linux trying to create one (or in general having generalized resource
allocation) is just a big mess and will cause endless problems.  The
standard resource code is just not up to the task and it needs very
intimate knowledge of the hardware that the kernel shouldn't have.

Again the real fix I think is to just drop all that code in git-x86
again and finally fix LinuxBIOS to do its job properly and pass a
proper MCFG (or just forget about using mmconfig with LinuxBIOS - it
is not that Type1 suddently doesn't work anymore). Then this code
wouldn't be needed at all

-Andi
