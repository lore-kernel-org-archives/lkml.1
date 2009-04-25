Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbZDYITi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbZDYITi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 04:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbZDYITW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 04:19:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50157 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbZDYITV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 04:19:21 -0400
Date: Sat, 25 Apr 2009 10:19:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, mark.langsdorf@amd.com, arekm@maven.pl,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [patch 2/2] x86 amd fix cmpxchg read acquire barrier
Message-ID: <20090425081914.GD2428@ucw.cz>
References: <20090422201852.092307236@polymtl.ca> <20090422202453.829846363@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090422202453.829846363@polymtl.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-04-22 16:18:54, Mathieu Desnoyers wrote:
> http://google-perftools.googlecode.com/svn-history/r48/trunk/src/base/atomicops-internals-x86.cc
> 
> says
> 
> "  // Opteron Rev E has a bug in which on very rare occasions a locked
>   // instruction doesn't act as a read-acquire barrier if followed by a
>   // non-locked read-modify-write instruction.  Rev F has this bug in 
>   // pre-release versions, but not in versions released to customers,
>   // so we test only for Rev E, which is family 15, model 32..63 inclusive.

Could we be more careful  here and catch the F pre-release versions,
too? Stepping should help there...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
