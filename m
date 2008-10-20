Return-Path: <linux-kernel-owner+w=401wt.eu-S1753944AbYJTWNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944AbYJTWNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 18:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbYJTWNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 18:13:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752899AbYJTWNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 18:13:08 -0400
Date: Mon, 20 Oct 2008 15:12:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: rakib.mullick@gmail.com, xiyou.wangcong@gmail.com, adobriyan@gmail.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] init: Properly placing noinline keyword.
Message-Id: <20081020151245.64101fbb.akpm@linux-foundation.org>
In-Reply-To: <20081017173123.GC19832@hack.voiplan.pt>
References: <b9df5fa10810170605t50e366e9nf62f8a18df37fc3c@mail.gmail.com>
	<20081017141354.GA9242@x200.localdomain>
	<b9df5fa10810170717p36dcb4a9y4e74089069dea03c@mail.gmail.com>
	<20081017142610.GA19832@hack.voiplan.pt>
	<b9df5fa10810170810x4d3e385n3a2284dd8b2600df@mail.gmail.com>
	<20081017173123.GC19832@hack.voiplan.pt>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008 18:31:23 +0100
Am__rico Wang <xiyou.wangcong@gmail.com> wrote:

> On Fri, Oct 17, 2008 at 09:10:07PM +0600, Rakib Mullick wrote:
> >On 10/17/08, Am__rico Wang <xiyou.wangcong@gmail.com> wrote:
> >> On Fri, Oct 17, 2008 at 08:17:33PM +0600, Rakib Mullick wrote:
> >>  >On 10/17/08, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> >>  >> On Fri, Oct 17, 2008 at 07:05:32PM +0600, Rakib Mullick wrote:
> >>  >>  > Here, noinline keyword should be placed between storage class and type.
> >>  >>
> >>  >>
> >>  >> Why?
> >>  >Because, scripts/checkpatch.pl warned with following warning:
> >>  >     ERROR: inline keyword should sit between storage class and type
> >>
> >>
> >> Well, 'noinline' is different from 'inline'.
> >>
> >>  'noinline' is defined as:
> >>
> >>  #define  noinline                       __attribute__((noinline))
> >>
> >>  in include/linux/compiler-gcc.h. But 'inline' is a _keyword_ defined
> >>  by C standard. If checkpatch.pl complains about 'noinline', you should
> >>  fix checkpatch.pl. :)
> >Thanks, for explanation. But isn't it nice to place it between storage
> >class and type ?
> 
> I don't think so, I don't know why checkpatch.pl prefers that style.
> I think probably only because that is more readable?
> 

I think it's good for consistency reasons.  Yes, we _could_ have a
random sprinkling of different keyword orderings, but what benefit is
there in that?  In the great majority of places the kernel uses `static
inline void' and `static noinline void' ordering, and that's a good
thing, no?

So I merged the patch and I'd support retaining the checkpatch warning.

My one concern is that the patch is too small.  Probably there are
other codesites which get the keywords in a non-standard order, and I'd
rather fix them up in a single big pass rather than in a long series of
little patches.

