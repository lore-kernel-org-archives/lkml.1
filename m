Return-Path: <linux-kernel-owner+w=401wt.eu-S1756735AbXFTW4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbXFTW4N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 18:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbXFTWz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 18:55:58 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44324 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751541AbXFTWz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 18:55:57 -0400
Date: Wed, 20 Jun 2007 15:54:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ian McDonald <ian.mcdonald@jandi.co.nz>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, "Darrick J. Wong" <djwong@us.ibm.com>,
       Andi Kleen <ak@suse.de>, Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       William Cohen <wcohen@redhat.com>,
       "S. P. Prasanna" <prasanna@in.ibm.com>,
       Antonino Daplas <adaplas@gmail.com>, Olaf Hering <olaf@aepfle.de>,
       Ville Syrj?l? <syrjala@sci.fi>, Jean Delvare <khali@linux-fr.org>,
       Rudolf Marek <r.marek@assembler.cz>, Soeren Sonnenburg <kernel@nn7.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [1/2] 2.6.22-rc5: known regressions with patches
In-Reply-To: <5640c7e00706201541g3ecaf8c5i524d8b464d8fcc2d@mail.gmail.com>
Message-ID: <alpine.LFD.0.98.0706201550480.3593@woody.linux-foundation.org>
References: <467543FA.60905@googlemail.com> 
 <5640c7e00706201508g3c1fc40eq82a1db05c9156b5d@mail.gmail.com> 
 <alpine.LFD.0.98.0706201536161.3593@woody.linux-foundation.org>
 <5640c7e00706201541g3ecaf8c5i524d8b464d8fcc2d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Jun 2007, Ian McDonald wrote:
> 
> It depends on the purpose of DEBUG_RODATA.  If DEBUG_RODATA was for
> security reasons then I agree, but it seems to be more to catch
> accidental writes.

Well, I'd say that it is *one* tool for debugging.

Now, Kprobes is another tool - and I'm just saying that I don't see why 
you should really expect to break one tool with the other. They take 
different approaches.

And yes, sometimes debugging *does* change what it debugs. In timing, if 
nothing else, but also in the kinds of things you can do. For example, we 
don't allow slab redzoning on data structures that have alignment 
restrictions not compatible with the redzoning, and I'd argue that this is 
more of the same: we just should not do DEBUG_RODATA if you expect to 
change read-only data.

There's just no *point*. 

		Linus
