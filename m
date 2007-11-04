Return-Path: <linux-kernel-owner+w=401wt.eu-S1755007AbXKDXxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbXKDXxy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 18:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbXKDXxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 18:53:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60787 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbXKDXxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 18:53:45 -0500
Message-ID: <472E5AB6.40509@zytor.com>
Date: Sun, 04 Nov 2007 15:50:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, tglx@linutronix.de,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] fix i486 boot failure due to stale %ds
References: <200711042158.lA4Lwv9S014628@harpo.it.uu.se> <472E50C5.5020201@goop.org>
In-Reply-To: <472E50C5.5020201@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>> Maybe not. I had a look in Intel's SDM Vol3, and the
>> section "switching to protected mode" specifies that
>> a move to %cr0 that sets PE should immediately be
>> followed by a far jmp or call.
> 
> Yes, that's what the spec says.  I queried this a few months ago, but
> hpa used his convincing voice and said that in practice it isn't
> necessary; there are no known cpus which need this, and any that do
> would cause other things to break.  But I guess now we have the
> counter-example...

Joy.  Apparently the Intel documentation is actually self-inconsistent. 
  Section 9.9.1, page 9-17 does indeed have the "far jump or call" 
injunction, whereas the sample code in section 9.10.1, page 9-27, line 
180 does a near jump!

	-hpa
