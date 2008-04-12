Return-Path: <linux-kernel-owner+w=401wt.eu-S1756472AbYDLWLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472AbYDLWLc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 18:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbYDLWLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 18:11:21 -0400
Received: from hpsmtp-eml11.kpnxchange.com ([213.75.38.111]:33100 "EHLO
	hpsmtp-eml11.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751816AbYDLWLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 18:11:21 -0400
From: Frans Pop <elendil@planet.nl>
To: Frederik Himpe <fhimpe@telenet.be>
Subject: Re: Audio skipping with 2.6.24.4 and 2.6.25-rc9
Date: Sun, 13 Apr 2008 00:11:15 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
References: <pan.2008.04.12.16.13.01@telenet.be> <20080412191914.GA6573@localhost.ift.unesp.br> <pan.2008.04.12.20.19.55@telenet.be>
In-reply-To: <pan.2008.04.12.20.19.55@telenet.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804130011.16616.elendil@planet.nl>
X-OriginalArrivalTime: 12 Apr 2008 22:11:17.0376 (UTC) FILETIME=[21399000:01C89CEA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederik Himpe wrote:
> I'm not too sure how I should use latencytop and interpret its results. I
> start latencytop, and reproduce the problem while rhythmbox is playing. It
> seems that it automatically changes the selected application in the bottom
> list after a few seconds, probably based on the CPU usage, where it
> selects most of the time either compiz or X. The upper half of latencytop
> is always empty, for all applications. In the lower half, it shows for all
> applications something like:
> 
> Process X (7972)
> Scheduler: waiting for cpu     43.5 msec         43.5 msec
> 
> Only the times differ between the different processes.

Had the same problem until just a few days ago when I figured it out mostly 
by accident.

You need to 'echo -n 1 > /proc/sys/kernel/latencytop' to enable latencytop 
tracing to get more useful info. It's something that's badly documented 
unfortunately. Make sure you disable it again when you're done so you don't 
keep the tracing overhead.
Not sure why starting the latencytop application does not enable tracing 
automatically, or at least provides an option to do so.

I also agree that the automatic switches to other apps are strange. Adding a 
particular app name or PID on the command line does not seem to have any 
effect.

Unfortunately the latencytop website also misses usage info and seems 
generally outdated as it still says that a patch to the kernel is required.

CC'ing Arjen in the hope that he can find some time to improve this.

Cheers,
FJP
