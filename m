Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbYI0T4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbYI0T4Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 15:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752912AbYI0T4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 15:56:18 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60799 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751816AbYI0T4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 15:56:17 -0400
Date: Sat, 27 Sep 2008 14:56:16 -0500
From: Jack Steiner <steiner@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] - UV fix for size of hub mappings
Message-ID: <20080927195615.GA244243@sgi.com>
References: <20080925125210.GA22404@sgi.com> <20080927174233.GB26047@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080927174233.GB26047@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2008 at 07:42:33PM +0200, Ingo Molnar wrote:
> 
> * Jack Steiner <steiner@sgi.com> wrote:
> 
> > Fix the size of the mappings of UV hub registers. Size must be a 
> > function of the maximum node number within the SSI.
> > 
> > Signed-off-by: Jack Steiner <steiner@sgi.com>
> 
> applied to tip/x86/uv, thanks Jack!
> 
> i'm wondering, the code still has a couple of ZZZ fixmes like:
> 
>  #ifdef ZZZ              /* Needs x2apic patch */
>  static void uv_send_IPI_self(int vector)
>  {
>          apic_write(APIC_SELF_IPI, vector);
>  }
>  #endif
> 
> x2apic support is available in tip/master, so it would be nice to glue 
> UV to generic x2apic support properly and remove duplication and fixmes.

Good point. I'll send the fixes to you early next week. Recently,
I've been focused on a distro release which is still waiting for
the x2apic code. However, I don't need to wait to fix this upstream...


> For example, do we really need apic_x2apic_uv_x, or could we use 
> apic_x2apic_cluster?

Unfortunately, we really need a uv genapic. IPIs on large UV systems
can't use an x2apic model. Because of the size of our large systems, APICIDs
in the cpu MSRs are not globally unique. We have a special feature
in the UV chipset that must be used for on large systems for IPIs.
Small & medium sized system can and do use the x2apic genapic.

--- jack
