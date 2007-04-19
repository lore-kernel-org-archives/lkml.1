Return-Path: <linux-kernel-owner+w=401wt.eu-S1423004AbXDSX5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423004AbXDSX5D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 19:57:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422999AbXDSX4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 19:56:34 -0400
Received: from ns.suse.de ([195.135.220.2]:35300 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423001AbXDSXy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 19:54:59 -0400
Message-Id: <20070419232303.300441585@schurl.suse.de>
User-Agent: quilt/0.46-1
Date: Fri, 20 Apr 2007 01:23:03 +0200
From: Andreas Gruenbacher <agruen@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Andrew Morton <akpm@linux-foundation.org>
References: <20070412090809.917795000@suse.de> <200704170335.21805.agruen@suse.de> <20070417182126.2327d89d@the-village.bc.nu>
In-Reply-To: <20070417182126.2327d89d@the-village.bc.nu>
Subject: [d_path 0/7] Fixes to d_path: Respin
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 April 2007 19:21, Alan Cox wrote:
> Can you prove no existing application on the planet relies on the
> existing behaviour ? Actually more limited but sane as a test would be
> "Can you prove that the glibc behaviour visible to applications does not
> change"

As far as I can see, glibc internally looks at /proc/mounts (or else mtab) to
find out where tmpfs is mounted for opening files there, and to look up
filesystem information for statfs(), while accessing that path, too. Fstatfs()
also looks into the same files, but it only matches by filesystem type, so this
is only a very unreliable heuristic, anyway.

So judging from that, glibc users should be fine.

> I disagree - firstly because of not breaking stuff, and secondly because
> it separates two discussions - merging AppArmor being one of them , and
> the correct behaviour for getcwd & /proc/mounts being the other.

I agree with the separation of discussion argument. Here are patches that
change getcwd() and /proc/mounts independent of the changes that AppArmor
depends on.

Thanks for your feedback!

Andreas

