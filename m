Return-Path: <linux-kernel-owner+w=401wt.eu-S932122AbZJBWo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbZJBWo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 18:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756608AbZJBWo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 18:44:27 -0400
Received: from outbound-mail-153.bluehost.com ([67.222.39.33]:40524 "HELO
	outbound-mail-153.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756646AbZJBWoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 18:44:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=fUbS1XnK+bGylaCnN5CAx2OpVccxRr7nFx3Yd5y4TdVO++Xw1Lb3ipZMk++9jXPP6+6SWe12DflT9pdCL47kmAQAMMKKlb7TIQAqHlN0VqGfm9doINg3apXIKi1Tsmi+;
Date: Fri, 2 Oct 2009 15:44:24 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.32 regression (bisected): Video tearing/glitching with T400
 laptops
Message-ID: <20091002154424.331f82a6@jbarnes-g45>
In-Reply-To: <E1Mtqnb-0002x7-TJ@closure.thunk.org>
References: <E1Mtqnb-0002x7-TJ@closure.thunk.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Oct 2009 18:40:27 -0400
"Theodore Ts'o" <tytso@mit.edu> wrote:

> Hi, 
> 
> In recent kernels, my X display (running with a KMS-enabled X server)
> has been very jittery and with lots of glitching and tearing --- sorry
> if this isn't the correct technical term, not sure what it is --- on
> my T400 Lenovo laptop.   It seems related to what is on the desktop,
> and moving the mouse does seem to affect the rate and percentage of
> the screen which jitters --- which is enough to be very distracting,
> although I can still read the contents of the windows where the screen
> is tearing/glitching/flashing.
> 
> I bisected it down to this commit:
> 
> 74dff282237ea8c0a5df1afd8526eac4b6cee063 is the first bad commit
> commit 74dff282237ea8c0a5df1afd8526eac4b6cee063
> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date:   Mon Sep 14 15:39:40 2009 -0700
> 
>     drm/i915: framebuffer compression for GM45+
>     
>     Add support for framebuffer compression on GM45 and above.
> Removes some unnecessary I915_HAS_FBC checks as well (this is now
> part of the FBC display function).
>     
>     Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>     Signed-off-by: Eric Anholt <eric@anholt.net>
> 
> ... and taking the latest git mainline, and I confirmed that the
> problem was still present, and then after reverting this commit, the
> problem went away.
> 
> I've included my Xorg.0.log file in case that's helpful.  Please let
> me know if there's anything else you need.

Yeah I've had a couple of other reports of flicker pointing to this
commit... I'll be able to look into it next week.

-- 
Jesse Barnes, Intel Open Source Technology Center
