Return-Path: <linux-kernel-owner+w=401wt.eu-S1751975AbYKMI03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbYKMI03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 03:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbYKMI0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 03:26:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39756 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbYKMI0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 03:26:20 -0500
Date: Thu, 13 Nov 2008 09:35:36 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rfc] x86: optimise page fault path a little
Message-ID: <20081113083536.GQ3810@one.firstfloor.org>
References: <20081113072821.GB2946@wotan.suse.de> <20081113074109.GB1723@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081113074109.GB1723@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> this flow could be cleaned up further:
> 
> [...]
> > +		bad_area(regs, error_code, address);
> > +		return;
> [...]
> > +		bad_area(regs, error_code, address);
> > +		return;
> [...]
> > +			bad_area(regs, error_code, address);
> > +			return;
> [...]
> > +		bad_area(regs, error_code, address);
> > +		return;
> 
> Any reason why that pattern shouldnt be changed to an appropriate goto 
> bad_area? (probably the same goes for the nosemaphore error paths too)

The tail call is already effectively a goto.

-Andi

-- 
ak@linux.intel.com
