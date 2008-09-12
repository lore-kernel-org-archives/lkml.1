Return-Path: <linux-kernel-owner+w=401wt.eu-S1755041AbYILLqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041AbYILLqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 07:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbYILLqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 07:46:42 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52136 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752477AbYILLql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 07:46:41 -0400
Date: Fri, 12 Sep 2008 06:46:38 -0500
From: Dean Nelson <dcn@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Alan Mayer <ajm@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, jeremy@goop.org, rusty@rustcorp.com.au,
       suresh.b.siddha@intel.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <Yinghai.lu@amd.com>
Subject: Re: [RFC 0/4] dynamically allocate arch specific system vectors
Message-ID: <20080912114638.GA2661@sgi.com>
References: <489C6844.9050902@sgi.com> <20080811165930.GI4524@elte.hu> <48A0737F.9010207@sgi.com> <m1y733mjdh.fsf@frodo.ebiederm.org> <20080911152304.GA13655@sgi.com> <48C979D3.5000308@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C979D3.5000308@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2008 at 01:04:35PM -0700, H. Peter Anvin wrote:
> Dean Nelson wrote:
> >
> >We (SGI) need somewhere around eight vectors.
> >
> >There are two kernel modules, sgi-gru and sgi-xp (in drivers/misc), that
> >each need two vectors. And there's the broadcast assist unit (BAU) that is
> >involved in tlb shootdown on uv, which currently uses statically reserved
> >vector 0xf8 (UV_BAU_MESSAGE -- see uv_bau_init()). I know of a debugger 
> >that
> >also uses 0xf8 because it was previously available until UV_BAU_MESSAGE 
> >came
> >along. The BAU would be happy with a dynamically allocated system vector.
> >We have a couple of other things in the works that also need vectors.
> >
> >All of these eight or so vectors are only meaningful on SGI uv systems.
> >
> 
> Are these kernel-internal vectors, or exposed to userspace (i.e. the INT 
> instruction works in userspace)?  From what I'm gathering, I think this 
> is the former.

Yeah, these are kernel-internal vectors and are not exposed to userspace.
