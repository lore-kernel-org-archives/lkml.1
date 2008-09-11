Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbYIKPXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbYIKPXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 11:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbYIKPXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 11:23:09 -0400
Received: from relay1.sgi.com ([192.48.171.29]:43063 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752761AbYIKPXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 11:23:08 -0400
Date: Thu, 11 Sep 2008 10:23:04 -0500
From: Dean Nelson <dcn@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alan Mayer <ajm@sgi.com>, Ingo Molnar <mingo@elte.hu>, jeremy@goop.org,
       rusty@rustcorp.com.au, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <Yinghai.lu@amd.com>
Subject: [RFC 0/4] dynamically allocate arch specific system vectors
Message-ID: <20080911152304.GA13655@sgi.com>
References: <489C6844.9050902@sgi.com> <20080811165930.GI4524@elte.hu> <48A0737F.9010207@sgi.com> <m1y733mjdh.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1y733mjdh.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 12:39:22PM -0700, Eric W. Biederman wrote:
>
> Although I am not at all convinced that dynamic allocation of
> the vector number (instead of statically reserving it makes sense).

We (SGI) need somewhere around eight vectors.

There are two kernel modules, sgi-gru and sgi-xp (in drivers/misc), that
each need two vectors. And there's the broadcast assist unit (BAU) that is
involved in tlb shootdown on uv, which currently uses statically reserved
vector 0xf8 (UV_BAU_MESSAGE -- see uv_bau_init()). I know of a debugger that
also uses 0xf8 because it was previously available until UV_BAU_MESSAGE came
along. The BAU would be happy with a dynamically allocated system vector.
We have a couple of other things in the works that also need vectors.

All of these eight or so vectors are only meaningful on SGI uv systems.

We'll go with which ever way you decide on this (dynamically allocated or
statically reserved).

But we really need to get something into 2.6.28. So in order to move forward
I'm submitting the following patchset for comment. This set of four patches
represents my take on Eric's suggested approach to supporting dynamically
allocated system vectors (i.e., __grab_irq_vector()).

Eric, is this what you were thinking of? Or did I miss the mark?

Thanks,
Dean
