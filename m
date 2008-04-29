Return-Path: <linux-kernel-owner+w=401wt.eu-S1760399AbYD2UE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760399AbYD2UE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759515AbYD2UEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:04:42 -0400
Received: from qb-out-0506.google.com ([72.14.204.237]:36361 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbYD2UEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:04:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DnEftSe0fPisPDQ5yLOK/ZoNRhv70TXQ4YvJIvtSNHZBSgJQjQt/O0vgQerhaGxJM9SYn9U2q6p5EXWr+7LXGlLetDWulOZAKc+uvUWk5J6AW3eNIRXzMY9TUS7t/n5t7GsnfD8CGV8Wf49X7SmmHBvK3waNcHMzPScGsl/+SDE=
Message-ID: <86802c440804291304r7ff169f6k9132f98761ecef42@mail.gmail.com>
Date: Tue, 29 Apr 2008 13:04:36 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete layout v5
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Gabriel C" <nix.or.die@googlemail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Mika Fischer" <mika.fischer@zoopnet.de>
In-Reply-To: <m1wsmg32qk.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804272337.40130.yhlu.kernel@gmail.com>
	 <200804281244.56938.yhlu.kernel@gmail.com>
	 <200804281316.14168.yhlu.kernel@gmail.com>
	 <200804281505.05764.yhlu.kernel@gmail.com>
	 <m1wsmg32qk.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 12:00 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Yinghai Lu <yhlu.kernel.send@gmail.com> writes:
>
>  > some BIOS like to use continus MTRR layout, and may X driver can not add
>  > WB entries for graphical cards when 4g or more RAM installed.
>  >
>  > the patch will change MTRR to discrete.
>  >
>  > mtrr_chunk_size= could be used to have smaller continuous block to hold holes.
>  > default is 256m, could be set according to size of graphics card memory.
>  >
>  > v2: fix -1 for UC checking
>  > v3: default to disable, and need use enable_mtrr_cleanup to enable this feature
>  >     skip the var state change warning.
>  >     remove next_basek in range_to_mtrr()
>  > v4: correct warning mask.
>  > v5: CONFIG_MTRR_SANITIZER
>  >
>  > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>
>  Skimming through the code it looks fairly sane.
>
>  I do think it would be good to split this patch into two pieces.
>  1) The mtrr rewriter/sanitizer/normalize.
>    All it does it should do is rewrite the MTRRs with a
>    semantically equivalent value.  This code should always be
>    safe and work on any system with MTRRs.
>
>    This works around otherwise sane bios's that simply prefer
>    to have contiguous MTRRs.
>
>    I don't see a reason why this code should be configurable.
>
>    This approach avoids earlier concerns because it starts
>    with the existing MTRR layout and not with the e820 map.
>
>  2) The mtrr_chunk_size code that rounds things off and allows
>    us to use discrete MTRRs by reducing some RAM to uncacheable.
>    Because it makes things uncacheable it has potentially bad
>    side effects on performance and thus potentially bad side
>    effects on functionality.  For areas like the SMM and ACPI
>    especially as they usually occur at the end of RAM just
>    below 4G.
>
>    The chunk size code should be configurable and default to off
>    because it has potential side effects.  A KConfig option may
>    also be appropriate.  It asks an interesting trade off question
>    do you want your BIOS to be fast or X.

(less memory + fast X) or  (more 8M RAM + slow...)

YH
