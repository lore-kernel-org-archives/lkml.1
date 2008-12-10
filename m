Return-Path: <linux-kernel-owner+w=401wt.eu-S1755646AbYLJC1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbYLJC1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 21:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbYLJC1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 21:27:02 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47563 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391AbYLJC1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 21:27:00 -0500
Date: Tue, 9 Dec 2008 21:26:11 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Dennis Hardy <dhardy@sogetthis.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: CIFS regression in 2.6.27.8
Message-ID: <20081209212611.25fcd053@tupile.poochiereds.net>
In-Reply-To: <20924383.post@talk.nabble.com>
References: <20900699.post@talk.nabble.com>
	<84144f020812081128p6d1e2a55v69996a360e7f0e8f@mail.gmail.com>
	<200812082112.49468.rjw@sisk.pl>
	<20081209154932.0952fbf3@dhcp-100-2-144.bos.redhat.com>
	<20924383.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Dec 2008 13:47:56 -0800 (PST)
Dennis Hardy <dhardy@sogetthis.com> wrote:

> 
> > I tried it on both i386 and x86_64 and had no problems. Is this client
> > non-x86 by any chance?
> 
> Curious...my kernel is CONFIG_X86_32=y and CONFIG_X86=y, CONFIG_MK6=y.
> 
> Perhaps this could be an issue with the Windows Server side (Windows Home
> Server, latest Windows SPs, etc.)  Maybe MSFT introduced some "improvement"
> in a recent update that caused an incompatibility of some sort.  I can try
> mounting some other Windows machines via CIFS from the 2.6.27.8 end and see
> what happens, plus boot back to 2.6.27.6 and compare.
> 

There is a problem with CIFS in 2.6.27.8, but it mainly manifests
itself as a kthread that doesn't shut down when it should (regression
due to a missing couple of prerequisite patches). I've got a patch for
2.6.27.9 that should fix that problem (assuming there is a .9)

The fixes that went into 2.6.27.8 were mostly patches to fix races on
mount and unmount and some fixes for socket handling. The problem
you've described seems very consistent and localized to an area that
wasn't patched in .8.

I could easily be wrong, but the problem you've described seems more
likely to be a server issue. If you can get binary network captures
between the client and server like Steve F. requested, then we should
be able to confirm it either way...

-- 
Jeff Layton <jlayton@redhat.com>
