Return-Path: <linux-kernel-owner+w=401wt.eu-S965705AbXBOMCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965705AbXBOMCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 07:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965710AbXBOMCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 07:02:13 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:16964 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965705AbXBOMCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 07:02:12 -0500
Date: Thu, 15 Feb 2007 15:09:20 +0300
From: Alexey Dobriyan <adobriyan@openvz.org>
To: Roland McGrath <roland@redhat.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: Re: utrace regressions (was: -mm merge plans for 2.6.21)
Message-ID: <20070215120920.GA11152@localhost.sw.ru>
References: <20070212125156.GA6035@localhost.sw.ru> <20070212213634.2777A1800E4@magilla.sf.frob.com> <20070213130530.GA6027@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213130530.GA6027@localhost.sw.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 04:05:30PM +0300, Alexey Dobriyan wrote:
> On Mon, Feb 12, 2007 at 01:36:34PM -0800, Roland McGrath wrote:
> > > 2. The following proggie renders box unusable in ~10 seconds (but not
> > >    mainline kernel where Ctrl+C will kill process).
> >
> > I haven't been able to reproduce this so far on my test machine.  I got
> > bored after about 10 minutes ("passed: 119200000").  The machine remains
> > responsive and the test dies immediately on hitting C-c.  I'll try it on
> > some other machines.  It would help to know what kind of unusable (crashy,
> > leaky, wedgey?).
> 
> This is fresh pull 2.6.20-ec2f9d1331f658433411c58077871e1eef4ee1b4 with
> linux-2.6.20-current-utrace.patch slapped on top (without rejects)
> utrace is on and ptrace is on too.
> 
> the behaviour is
> 
> 	$ expl_ptratt
> 	passed: 100000
> 	passed: 200000
> 		...
> 	passed: [always different number, but in several seconds]
> 		[pause]
> 	[OOM killer wakes up steadily killing processes	]
> 	[messages scroll away				]
> 
> I'll turn more debugging options now.
> 
> Just in case, .config:

Turning preempt off makes OOM-killings dissapear.

> # CONFIG_PREEMPT_NONE is not set
> CONFIG_PREEMPT_VOLUNTARY=y
> # CONFIG_PREEMPT is not set
> # CONFIG_X86_UP_APIC is not set

