Return-Path: <linux-kernel-owner+w=401wt.eu-S1756437AbXHAWfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbXHAWfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 18:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbXHAWfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 18:35:08 -0400
Received: from main.gmane.org ([80.91.229.2]:37517 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058AbXHAWfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 18:35:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Christopher Hoover <ch@murgatroid.com>
Subject: Re: LinuxPPS & spinlocks
Date: Wed, 1 Aug 2007 22:14:54 +0000 (UTC)
Message-ID: <loom.20070802T000504-963@post.gmane.org>
References: <1185288769.14697.339.camel@pmac.infradead.org> <20070727184418.GV9840@enneenne.com> <46AA42CA.4060004@nortel.com> <20070727192848.GW9840@enneenne.com> <46AA4A1E.8040302@nortel.com> <20070727194516.GX9840@enneenne.com> <a781481a0707271347w53dd9755j87e7762cfe953777@mail.gmail.com> <a781481a0707271641n20353a12u7467d093346f2f4c@mail.gmail.com> <20070729095040.GZ9840@enneenne.com> <alpine.LFD.0.999.0707301033180.10861@enigma.security.iitk.ac.in> <20070730085157.GE9840@enneenne.com> <alpine.LFD.0.999.0707301438190.13448@enigma.security.iitk.ac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 69.17.55.116 (Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; WOW64; SLCC1; .NET CLR 2.0.50727; .NET CLR 3.0.04506))
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma <satyam <at> infradead.org> writes:
> On Mon, 30 Jul 2007, Rodolfo Giometti wrote:
> 
> > On Mon, Jul 30, 2007 at 10:33:35AM +0530, Satyam Sharma wrote:
> > Currently the RFC says to you that you should open the serial port:
> > 
> > 	fd = open("/dev/ttyS0", ...);
> 
> No, it does *NOT*. All it says is:
> 
>     The time_pps_create() is used to convert an already-open UNIX file
>     descriptor, for an appropriate special file, into a PPS handle.
> 
> See? What I said is precisely the implementation the RFC envisages
> (and the only sane way to implement it too).

If we were totally rigurous about representing each device as a device node, 
your solution would be fine.  But we don't.

The clocksource model (/sys/devices/system/clocksource) is a better way to 
go.  One sysfs file is used to enumerate the possible sources and another is 
used to read or set the current source.   No new system calls; no new ioctls.

-ch

ch (at) murgatroid (dot) com
ch (at) hpl (dot) hp (dot) com




