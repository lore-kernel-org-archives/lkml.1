Return-Path: <linux-kernel-owner+w=401wt.eu-S1758929AbZBEUNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758929AbZBEUNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 15:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753506AbZBEUNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 15:13:38 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:52427 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbZBEUNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 15:13:37 -0500
Date: Thu, 5 Feb 2009 20:12:44 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Ingo Molnar <mingo@elte.hu>
cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       William Lee Irwin III <wli@movementarian.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: pud_bad vs pud_bad
In-Reply-To: <20090205194932.GB3129@elte.hu>
Message-ID: <Pine.LNX.4.64.0902052004550.12955@blonde.anvils>
References: <498B2EBC.60700@goop.org> <20090205184355.GF5661@elte.hu>
 <498B35F9.601@goop.org> <20090205191017.GF20470@elte.hu>
 <Pine.LNX.4.64.0902051921150.30938@blonde.anvils> <20090205194932.GB3129@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Feb 2009, Ingo Molnar wrote:
> * Hugh Dickins <hugh@veritas.com> wrote:
> > 
> > Simpler and more compact, but not as strict: in particular, a value of
> > 0 or 1 is identified as bad by that 64-bit test, but not by the 32-bit.
> 
> yes, indeed you are right - the 64-bit test does not allow the KERNPG_TABLE 
> bits to go zero.
> 
> Those are the present, rw, accessed and dirty bits. Do they really matter 
> that much? If a toplevel entry goes !present or readonly, we notice that 
> _fast_, without any checks. If it goes !access or !dirty - does that matter?

I've not given it a great deal of thought, why this or that bit.
These p??_bad checks originate from 2.4 or earlier, and by mistake
got weakened somewhere along the way, and last time it was discussed
we agreed to strenghthen them (and IIRC Jeremy himself did so).

> 
> These checks are done all the time, and even a single instruction can count. 
> The bits that are checked are enough to notice random memory corruption.

Well, I am surprised that you would be arguing for weakening such
a very simple check.

Hugh
