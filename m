Return-Path: <linux-kernel-owner+w=401wt.eu-S1764483AbYCGN0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764483AbYCGN0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 08:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760119AbYCGN00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 08:26:26 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42073 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760110AbYCGN0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 08:26:25 -0500
Date: Fri, 7 Mar 2008 14:27:58 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Christoph Hellwig <hch@infradead.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] x86, fpu: lazy allocation of FPU area - v3
Message-ID: <20080307132758.GF7365@one.firstfloor.org>
References: <20080304014306.GC28006@linux-os.sc.intel.com> <20080304103220.GA17621@elte.hu> <20080304175528.GD28006@linux-os.sc.intel.com> <20080305194705.GA4386@ucw.cz> <20080306155141.GA23340@elte.hu> <20080306202446.GA4225@ucw.cz> <47D1352F.6010504@zytor.com> <47D13DEF.6030006@linux.intel.com> <20080307131841.GE7365@one.firstfloor.org> <47D1412C.50404@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D1412C.50404@linux.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 07:20:44AM -0600, Arjan van de Ven wrote:
> Andi Kleen wrote:
> >>this is just for handling the case where that fails
> >>(basically near/totally OOM or the case where you get a fatal signal)
> >
> >I didn't think GFP_KERNEL was interruptible by signals...
> >(although sometimes under oom thrashing I think it would be great if it 
> >was...) 
> 
> we need to make it (or with GFP_KILLABLE); would make total sense...
> (so yeah it was more wishful thinking than reality)

I think it wouldn't be that difficult for the normal anonymous user allocations
(standard page fault path), but doing it for everything would be pretty
hard because you would need to add signal-bail-out paths everywhere. 

But doing it for some simple cases like page fault only would be a nice 
project for someone, shouldn't be too difficult.

-Andi
