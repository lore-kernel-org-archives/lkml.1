Return-Path: <linux-kernel-owner+w=401wt.eu-S1761301AbZENRXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761301AbZENRXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 13:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278AbZENRXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 13:23:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45154 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289AbZENRXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 13:23:32 -0400
Date: Thu, 14 May 2009 19:29:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Tobias Doerffel <tobias.doerffel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Specific support for Intel Atom architecture
Message-ID: <20090514172901.GH10933@one.firstfloor.org>
References: <200904301408.09370.tobias.doerffel@gmail.com> <877i0xib7d.fsf@basil.nowhere.org> <a36005b50905120720p14e0ea0av79f99551262a920a@mail.gmail.com> <20090512150408.GH19296@one.firstfloor.org> <a36005b50905121045s62c16760p3aba003647a572c7@mail.gmail.com> <1242277453.23058.35.camel@brick> <a36005b50905140638r56f73095kfc669bae1333e2bd@mail.gmail.com> <20090514140138.GB10933@one.firstfloor.org> <a36005b50905140919m3ab2356cqb3b8a32fd507e49e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a36005b50905140919m3ab2356cqb3b8a32fd507e49e@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 09:19:38AM -0700, Ulrich Drepper wrote:
> On Thu, May 14, 2009 at 7:01 AM, Andi Kleen <andi@firstfloor.org> wrote:
> > How would you test that?
> 
> Compare runtimes with mov+bswap for some simple code which uses the
> value after the conversion (e.g., just add to something).
> 
> Or in your case: get the Atom designers to comment.

Don't really need Atom designers; you can prove or disprove my theory
(that they generate the same uops sequence) by checking the uops performance
counter for a micro benchmark.

However even if that was not the case I have some doubts the
kernel is doing enough endian conversions that it really matters.

For example the network stack is doing maybe 4-5 endian conversions
(very conservative estimate) per packet and processing a packet
takes tens of thousands of cycles. But at best you could save 1-2 cycles
this way, so even if you save a few cycles this way it will be very likely 
in the noise.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
