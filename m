Return-Path: <linux-kernel-owner+w=401wt.eu-S1758763AbYH2RGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763AbYH2RGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 13:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756458AbYH2RGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 13:06:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42181 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276AbYH2RF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 13:05:59 -0400
Message-ID: <48B82B96.30401@zytor.com>
Date: Fri, 29 Aug 2008 10:02:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory corruption
References: <48B701FB.2020905@goop.org> <Pine.LNX.4.64.0808290817190.21494@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0808290817190.21494@blonde.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> 
> hpa introduced the 64k idea, and we've all been repeating it;
> but I've not heard the reasoning behind it.  Is it a fundamental
> addressing limitation within the BIOS memory model?  Or a case
> that Windows treats the bottom 64k as scratch, so BIOS testers
> won't notice if they corrupt it?
> 
> The two instances of corruption we've been studying have indeed
> been below 64k (one in page 8 and one in page 11), but that's
> because they were both recognizable corruptions of direct map PMDs.
> 
> If there is not a very strong justification for that 64k limit,
> then I don't think this approach will be very useful, and we should
> simply continue to rely on analyzing corruption when it appears, and
> recommend memmap= as a way of avoiding it once analyzed.  If there
> is a strong justification for it, please dispel my ignorance!
> 

The 64K number was empirical, of course.  The bottom 64K is somewhat 
special, however, in that it is what you can address in real mode (as 
opposed to big real mode) with your segments parked at zero, so you end 
up with something approaching a flat real mode.  Especially the first 
32K (below 0x7c00) are frequently used by various BIOS items, but I 
believe the corruption observed was at 0x8000, so it's beyond even this 
first barrier.

Obviously, it's extremely hard to predict where BIOS vendors will have 
choosen to scribble, but the observations in this particular case seemed 
to finger this particular area.

	-hpa
