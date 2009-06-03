Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbZFCDOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbZFCDOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 23:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbZFCDOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 23:14:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:34850 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbZFCDOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 23:14:12 -0400
Message-ID: <4A25EA78.7070705@kernel.org>
Date: Wed, 03 Jun 2009 12:14:00 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Niel Lambrechts <niel.lambrechts@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux.kernel" <linux-kernel@vger.kernel.org>,
       Theodore Tso <tytso@mit.edu>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
References: <clqON-2Xv-7@gated-at.bofh.it>	<clqON-2Xv-15@gated-at.bofh.it>	<clqON-2Xv-17@gated-at.bofh.it>	<clqON-2Xv-19@gated-at.bofh.it>	<clqON-2Xv-5@gated-at.bofh.it>	<cmknZ-8lW-9@gated-at.bofh.it>	<cmoBl-6Ok-21@gated-at.bofh.it>	<cmp4n-7rb-15@gated-at.bofh.it>	<cmsYg-5BR-27@gated-at.bofh.it>	<cmvW7-1Yj-23@gated-at.bofh.it>	<cnheh-3vO-7@gated-at.bofh.it>	<cnPg1-7Q4-19@gated-at.bofh.it>	<cnTWo-7bV-25@gated-at.bofh.it>	<co1Kd-350-5@gated-at.bofh.it>	<co2Qf-4QQ-27@gated-at.bofh.it>	<co4yj-7Mc-5@gated-at.bofh.it>	<cp71c-4py-29@gated-at.bofh.it>	<cEVyE-re-1@gated-at.bofh.it>	<4A17C39E.2030302@gmail.com>	<4A19F006.3000303@kernel.org> <20090525091534.13ae103c@lxorguk.ukuu.org.uk> <4A1B164B.1010108@gmail.com> <4A1B76EB.9040500@kernel.org> <4A1B8193.1010703@gmail.com> <4A1B8328.80801@kernel.org> <4A1B8873.1040101@gmail.com> <4A1BEFB6.80205@kernel.org> <4A1C316C.9040201@gmail.com> <4A1C8444.9040605@kernel.org> <4A1D47C6.1070504@gmail.com> <4A2424A2.5020704@gmail.com>
In-Reply-To: <4A2424A2.5020704@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Jun 2009 03:14:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Niel.

Niel Lambrechts wrote:
> Did you perhaps have any time to look into my feedback around the
> readahead patch?

Yeah, I've been thinking about it and am a bit out of ideas, so no
immediate follow-up.

>>From my side, I tried on Saturday to bisect this problem again, doing
> 5-8 hibernates per each bisect from 2.6.28. I stopped at 2.6.30-rc2 due
> time (or fatigue), and did not manage to replicate the problem at all
> which is strange since I was playing audio, doing finds and even doing
> an entire dd of the root partition. I saved the bisect logs so perhaps I
> can continue to see if the problem becomes more prevalent in later
> versions - the first time it ever happened to me was somewhere in 2.6.29
> originally.
> 
> The other interesting thing was to see that "hard resetting link"
> messages seem to first start appearing at v2.6.29-rc7 or perhaps rc8. Is
> it worth trying to track down the commit that lead to this?
> 
> Do you have any other debug patches to try, or should I try to delve
> deeper into finding commits that can be reverted? I'm running out of
> ideas, I even tried to find later firmware for my drive, but I seem to
> be on the latest level.

Given the non-deterministic nature of the failure, I think bisection
would be quite difficult.  I think the best way to diagnose the
problem is to track down the owner of the failed request.  It has
FAILFAST set and yet the issuer fails to deal with an error condition
which is expected when FAILFAST is set.  I'll prep a patch to track
request / bio failure.

Thanks.

-- 
tejun
