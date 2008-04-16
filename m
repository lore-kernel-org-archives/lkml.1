Return-Path: <linux-kernel-owner+w=401wt.eu-S1763663AbYDPOeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763663AbYDPOeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 10:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764903AbYDPOeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 10:34:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48246 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764848AbYDPOeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 10:34:20 -0400
Date: Wed, 16 Apr 2008 07:34:09 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Does process need to have a kernel-side stack all the time?
Message-ID: <20080416073409.15cf9481@laptopd505.fenrus.org>
In-Reply-To: <200804161620.43536.vda.linux@googlemail.com>
References: <200804141547.57719.vda.linux@googlemail.com>
	<87hce4uya8.fsf@basil.nowhere.org>
	<20080416124728.GA5050@elte.hu>
	<200804161620.43536.vda.linux@googlemail.com>
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

On Wed, 16 Apr 2008 16:20:43 +0200
Denys Vlasenko <vda.linux@googlemail.com> wrote:

> 
> And my "random thought" occurred along the lines "Ingo once ran
> 100000 threads and then ran out of space for stack... wait a minute!
> Why every single one of those threads need to have a stack at the
> same time? They sure as hell can't actively use more than NR_CPUS
> stacks at once!".
> 
> Pity it wouldn't work.

you could make it work ... sort of.
That is, you can deal with the case with apps that sleep on select/poll/sleep
(which is the majority)
by starting out at a small stack (say 512 bytes), and then in the syscall code switch
to a 4Kb stack for all but these 3 "known to not go deep but normal sleepers" syscalls.

I doubt it's worth the complexity, but it very likely could be made to work.... it's just
going to get very messy (how to deal with "current" is just the start of the messyness)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
