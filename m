Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbZJOO22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbZJOO22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 10:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbZJOO21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 10:28:27 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:63740 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806AbZJOO21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 10:28:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OEGLIUd/xwexdZ6kHkvDK6Z7i+O2f/HZOc795NweKGHbw7WP6gMKmmtw0WrzCM+idq
         wWlAQIf+jNG/PJo3ISJl9hjFxLJQ/9dIYnNrFElYc4KGZJEYZqMIfBiwciKp2Y/Qenbb
         fO9VWHpu0/5GucgBUOhK1tZFbKpLg7+Mhavn0=
Date: Thu, 15 Oct 2009 18:27:37 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, yinghai@kernel.org,
       macro@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] x86,apic: limit apic dumping, introduce show_lapic
	setup option
Message-ID: <20091015142737.GB5331@lenovo>
References: <20091013200702.019870576@openvz.org> <20091013201022.926793122@openvz.org> <20091014071217.GL784@elte.hu> <20091014150904.GA5259@lenovo> <20091014175616.GA3403@elte.hu> <20091014202941.GE5259@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014202941.GE5259@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Thu, Oct 15, 2009 at 12:29:41AM +0400]
| [Ingo Molnar - Wed, Oct 14, 2009 at 07:56:16PM +0200]
| | 
| | btw., i'm getting this warning on a test-box:
| ...
| | 
| | [    0.400000] Checking 'hlt' instruction... OK.
| | [    0.440000] SMP alternatives: switching to UP code
| | [    0.450000] debug: unmapping init memory 79c7a000..79c80000
| | 
| | noop_default_phys_pkg_id() should return 0 i guess, and not generate a 
| | warning?
| | 
| | 	Ingo
| | 
| 
| Ingo, I think the better would be to just make NOOP plain
| NOOP without any kind of checking. Something like below
| (I still can't fetch last/fresh -tip repo /remote point hangs/
|  for this so I've used interdiff).
| 
| Comments?
| 
| Btw, the base problem from dump you posted is that we've been
| cheking only for read/write operations allowing all other ops
| be called without any kind of check (and retrieving pkgid happened
| there all the time just didn't trigger warn until we've substituted
| apic driver completely). Using NOOP without warn should be more
| convenient (all previous "dark" places in apic code already covered
| with cpu_has_apic/disable_apic checks so the only risk we have --
| is code that will appear in future).
| 
| 	-- Cyrill
| ---

Ingo, please don't apply it yet. I think there is a nit.
Checking now. Will resend later the proper patch.

	-- Cyrill
