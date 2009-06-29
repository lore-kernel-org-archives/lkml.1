Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbZF2XFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbZF2XFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 19:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbZF2XFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 19:05:00 -0400
Received: from main.gmane.org ([80.91.229.2]:58254 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752828AbZF2XFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 19:05:00 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Mark Wielaard <mjw@redhat.com>
Subject: Re: Dual-licensing LTTng, marker and tracepoints =?utf-8?b?dW5kZXIJR1BMdjIrL0xHUEx2Mi4xKw==?=
Date: Mon, 29 Jun 2009 23:00:19 +0000 (UTC)
Message-ID: <loom.20090629T224818-688@post.gmane.org>
References: <4A412702.80707@polymtl.ca> <20090623191128.GA19010@Krystal> <20090623191513.GA20253@Krystal> <20090624004356.GB28911@Krystal> <20090624083334.GB16850@elte.hu> <20090624141438.GA15420@Krystal> <y0mprctzj5v.fsf@fche.csb> <20090624164909.GA20653@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 80.101.103.228 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b4) Gecko/20090427 Fedora/3.5-0.20.beta4.fc11 Firefox/3.5b4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <compudj <at> krystal.dyndns.org> writes:
> * Frank Ch. Eigler (fche <at> redhat.com) wrote:
> > > [...]The goal is to permit this library, which includes the
> > > tracepoints, markers and LTTng features, to be used by userspace
> > > applications and libraries so they can add static instrumentation
> > > (as we currently do in the kernel). [...]
> > 
> > Just in case you're not aware, some API prior art for this is the
> > dtrace sdt.h widget (already supported by systemtap), and of course
> > it has no similarity to the various kernel tracing APIs.
> 
> Yep, we're aware of this. However, last time I checked, dtrace SDT used
> a breakpoint even for their userspace tracing, which has a way too large
> performance overhead for our needs.

You might want to check again. Although the systemtap sdt.h should be source
compatible with dtrace markers since it provides the same compile time
interfaces/macros (which is how systemtap support java hotspot probing for
example), it isn't tied to any implementation details. The default
implementation inserts a NOP that can be replaced by a breakpoint instruction.
But Stan Cox added variants that can use syscalls/utrace/kprobes which have
different performance overhead tradeoffs
(http://article.gmane.org/gmane.linux.systemtap/12667). This is an
implementation detail though since the source interfaces are the same. Just
recompiling your application and/or libraries against a newer version of the
sdt.h interfaces will automagically provide the different probe types.

Cheers,

Mark

