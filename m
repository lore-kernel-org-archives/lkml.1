Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbYCITMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbYCITMY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 15:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbYCITMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 15:12:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52116 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbYCITMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 15:12:14 -0400
Date: Sun, 9 Mar 2008 12:11:03 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: quicklists confuse meminfo
Message-ID: <20080309121103.3f7019d5@laptopd505.fenrus.org>
In-Reply-To: <20080309123432.GA3267@elte.hu>
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de>
	<20080309111456.GA21690@elte.hu>
	<20080309210000.C6DE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080309120940.GA1695@elte.hu>
	<20080309123432.GA3267@elte.hu>
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

On Sun, 9 Mar 2008 13:34:32 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > IMHO we need shrink pgtable cache mecanism.
> > 
> > ouch! Could you try the patch below? How large is the quicklist
> > cache with this applied?
> 
> hm, Thomas pointed it out that this wont solve all the problems as 
> quicklists have a built-in "preserve me" throttle (which is rather 
> stupid).
> 
> the right solution is to get rid of quicklists altogether (Thomas 
> expects to have patches for that later today).

careful with this; the quicklists aren't JUST for speed
they are also there to make sure a page we free that is a pagetable,
is not reused until we have finished flushing the tlbs on all the cpus that saw it.
This is a really hard correctness requirement, and while I can see
that quicklists are probably not the best way to achieve this, we can't just
throw away the behavior ;(

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
