Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbYDJOBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbYDJOBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 10:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbYDJOBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 10:01:32 -0400
Received: from twin.jikos.cz ([213.151.79.26]:53914 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbYDJOBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 10:01:31 -0400
Date: Thu, 10 Apr 2008 16:01:27 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Michal Hocko <mhocko@suse.cz>
cc: Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: file offset corruption on 32-bit machines?
In-Reply-To: <200804101555.58643.mhocko@suse.cz>
Message-ID: <Pine.LNX.4.64.0804101558280.26562@twin.jikos.cz>
References: <Pine.SOC.4.64.0804081101430.28938@math.ut.ee>
 <200804101555.58643.mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2008, Michal Hocko wrote:

> > Jeff Robertson analyzes the behaviour of different operating systems'
> > 64-bit file offset implementation and concludes that on 32-bit
> > machines, Linux and Solaris lack any locking to keep the two 32-bit
> > halves in sync and this could cause rare file offset corruption.
> > http://jeffr-tech.livejournal.com/21014.html
> AFAICS, this race is theoretically possible, but it is very hard (almost 
> impossible) to trigger with a sane file usage pattern. Note that you 
> have to access shared struct file (same file descriptor) in different 
> threads which should be synchronized by caller anyway (*).

... but not in cases the caller is an intentionally evil code, right? :)

> I also don't see any security implications from this race, but maybe 
> someone with more knowlage about fs can see (f_pos is used at many 
> places in the kernel code).

The f_pos races are in fact exploitable, we've already been there. See 
for example http://www.isec.pl/vulnerabilities/isec-0016-procleaks.txt

-- 
Jiri Kosina
SUSE Labs

