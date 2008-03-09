Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbYCIKaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbYCIKaJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 06:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbYCIK36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 06:29:58 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:3594 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbYCIK35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 06:29:57 -0400
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Lameter <clameter@sgi.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: quicklists confuse meminfo
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de>
From: Andi Kleen <andi@firstfloor.org>
Date: 09 Mar 2008 11:29:54 +0100
In-Reply-To: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de>
Message-ID: <87iqzw197h.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Mar 2008 10:23:23.0475 (UTC) FILETIME=[9AC31A30:01C881CF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> Bart reported http://bugzilla.kernel.org/show_bug.cgi?id=9991. He
> assumed a memory leak in 32bit kernels when he analyzed the output of
> /proc/meminfo.
> 
> The leak is not a leak, it's an accounting bug. quicklists keep a
> large amount of pages which are accounted as used memory.

There are various other subsystems which can cache substantial memory
under the right circumstances. Do you want to add all of them 
to /proc/meminfo? I'm not sure that will scale long term.

One more general possibility would be to integrate this with
with the shrinker callbacks. Everyone who caches memory should
have a shrinker. Perhaps that could be integrated with some reporting
facility that adds a dynamic counter field that is displayed
somewhere in /proc or /sys.

-Andi
