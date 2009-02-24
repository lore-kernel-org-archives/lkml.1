Return-Path: <linux-kernel-owner+w=401wt.eu-S1757912AbZBXOsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912AbZBXOsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 09:48:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbZBXOrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 09:47:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:57672 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164AbZBXOrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 09:47:52 -0500
Message-ID: <49A4087B.8080405@kernel.org>
Date: Tue, 24 Feb 2009 23:47:23 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jeremy@goop.org,
       cpw@sgi.com, nickpiggin@yahoo.com.au, ink@jurassic.park.msu.ru
Subject: Re: [PATCHSET x86/core/percpu] improve the first percpu chunk	allocation
References: <1235445101-7882-1-git-send-email-tj@kernel.org> <20090224095708.GA20739@elte.hu> <49A3DE76.5010606@kernel.org> <20090224125132.GB31295@elte.hu>
In-Reply-To: <20090224125132.GB31295@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 24 Feb 2009 14:47:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ingo Molnar wrote:
--snip--
> So what i'm saying is that these are strong reasons for us to 
> want to make the unit size to be something like 2MB - on 64-bit 
> x86 at least.
>
> ( Using a 2MB unit size will also have another advantage: _iff_ 
>   we can still allocate a hugepage at that point we can map it 
>   straight there when extending the dynamic area. )

Thanks for the explanation.  Yeap, it would be nice to have units
aligned on 2MB boundary.  We'll need to add @align to vm area alloc
function to do it correctly.  As for using large page, it would be
nice if we can do that automatically.  Upfront 2MB unit allocation is
probably too expensive but merging 4k pages into a large page (if we
can get them) will add a lot of irregular latency too.  Hmmm...

-- 
tejun
