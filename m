Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbYCJTEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbYCJTEb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 15:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbYCJTEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 15:04:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34594 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbYCJTEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 15:04:23 -0400
Date: Mon, 10 Mar 2008 20:06:11 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>, Hugh Dickins <hugh@veritas.com>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: quicklists confuse meminfo
Message-ID: <20080310190611.GA9246@one.firstfloor.org>
References: <20080309210000.C6DE.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080309120940.GA1695@elte.hu> <20080309123432.GA3267@elte.hu> <20080309114640.85c9c3eb.akpm@linux-foundation.org> <Pine.LNX.4.64.0803100851560.23575@schroedinger.engr.sgi.com> <87myp68r88.fsf@basil.nowhere.org> <Pine.LNX.4.64.0803101707070.3398@blonde.site> <47D57056.3050204@goop.org> <20080310175305.GC7692@one.firstfloor.org> <47D57F86.2020806@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D57F86.2020806@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 11:35:50AM -0700, Jeremy Fitzhardinge wrote:
> Hm, given that Xen doesn't make any topology guarantees about vcpus, I 
> don't think it would make much difference.  I think it would only be 
> observable if you actually pinned the vcpus to physical siblings.  
> Besides we could easily maintain sibling info and look to see if we're 
> about to reload cr3 to match the other thread(s), then just use the same 
> pgd copy.

The optimization doesn't really require any topology information; 
you just should make sure that if you have a VM shared between
different CPUs that it has the same CR3. The easiest way to enforce
that is to always only use a single CR3 for a VM.

-Andi
