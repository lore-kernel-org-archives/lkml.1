Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbYAOQZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbYAOQZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 11:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbYAOQZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 11:25:11 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:35666 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbYAOQZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 11:25:10 -0500
Date: Tue, 15 Jan 2008 17:25:13 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       rjw@sisk.pl, pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without HOTPLUG_CPU
Message-ID: <20080115162513.GA18338@uranus.ravnborg.org>
References: <20080110124702.GF28740@does.not.exist> <p73fxx5omck.fsf@bingen.suse.de> <20080110150911.GG28740@does.not.exist> <20080114135240.GA15357@elte.hu> <20080114140910.GA8507@uranus.ravnborg.org> <20080114145854.GA31695@elte.hu> <20080114150553.GA3524@elte.hu> <20080114152440.GA9174@elte.hu> <20080114201214.GC9257@uranus.ravnborg.org> <20080115151742.GB10722@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115151742.GB10722@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 04:17:42PM +0100, Ingo Molnar wrote:
> 
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > > find below the current set of warnings on -git. There are 62.
> > 
> > The correct figure is 112.
> > 
> > You need to do a:
> > make KCFLAGS=-fno-unit-at-a-time
> > build to see them all.
> 
> btw., please add a .config option to trigger the -fno-unit-at-a-time 
> flags. Something like CONFIG_SECTION_ERRORS=y - plus perhaps combine it 
> with the patch below that turns such section bugs into detectable build 
> errors. A distro does not want to build a kernel that could potentially 
> corrupt kernel memory. (it's a security risk as well.) If we make the 
> err=1 dependent on CONFIG_SECTION_ERRORS then we'll have this 
> configurable.

The plan is to let section mismatch warnings become errors 
after the merge window - so we hit -mm first.
And I will add a config option to:
- set -fno-unit-at-a-time
- add no-inline to all functions marked __init*
- and maybe disable __inline if that gives additional errors

Slowly getting there.
Need to beat modpost in shape to get much less configuration
dependent warnings/errors first.

	Sam
