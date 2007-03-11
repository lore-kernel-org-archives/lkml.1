Return-Path: <linux-kernel-owner+w=401wt.eu-S932313AbXCKLst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313AbXCKLst (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 07:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933267AbXCKLst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 07:48:49 -0400
Received: from mail11.syd.optusnet.com.au ([211.29.132.192]:38230 "EHLO
	mail11.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932313AbXCKLss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 07:48:48 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Date: Sun, 11 Mar 2007 22:48:23 +1100
User-Agent: KMail/1.9.5
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
References: <200703111457.17624.kernel@kolivas.org> <1173613149.6927.29.camel@Homer.simpson.net>
In-Reply-To: <1173613149.6927.29.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703112248.24192.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 March 2007 22:39, Mike Galbraith wrote:
> Hi Con,
>
> On Sun, 2007-03-11 at 14:57 +1100, Con Kolivas wrote:
> > What follows this email is a patch series for the latest version of the
> > RSDL cpu scheduler (ie v0.29). I have addressed all bugs that I am able
> > to reproduce in this version so if some people would be kind enough to
> > test if there are any hidden bugs or oops lurking, it would be nice to
> > know in anticipation of putting this back in -mm. Thanks.
> >
> > Full patch for 2.6.21-rc3-mm2:
> > http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-mm2-rsdl-0.29
> >.patch
>
> I'm seeing a cpu distribution problem running this on my P4 box.
>
> Scenario:
> listening to music collection (mp3) via Amarok.  Enable Amarok
> visualization gforce, and size such that X and gforce each use ~50% cpu.
> Start rip/encode of new CD with grip/lame encoder.  Lame is set to use
> both cpus, at nice 5.  Once the encoders start, they receive
> considerable more cpu than nice 0 X/Gforce, taking ~120% and leaving the
> remaining 80% for X/Gforce and Amarok (when it updates it's ~12k entry
> database) to squabble over.
>
> With 2.6.21-rc3,  X/Gforce maintain their ~50% cpu (remain smooth), and
> the encoders (100%cpu bound) get whats left when Amarok isn't eating it.
>
> I plunked the above patch into plain 2.6.21-rc3 and retested to
> eliminate other mm tree differences, and it's repeatable.  The nice 5
> cpu hogs always receive considerably more that the nice 0 sleepers.

Thanks for the report. I'm assuming you're describing a single hyperthread P4 
here in SMP mode so 2 logical cores. Can you elaborate on whether there is 
any difference as to which cpu things are bound to as well? Can you also see 
what happens with lame not niced to +5 (ie at 0) and with lame at nice +19.

Thanks.

-- 
-ck
