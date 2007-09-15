Return-Path: <linux-kernel-owner+w=401wt.eu-S1758356AbXIOIJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758356AbXIOIJe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 04:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbXIOIJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 04:09:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44294 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752912AbXIOIJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 04:09:17 -0400
Date: Sat, 15 Sep 2007 01:08:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Simon Derr <Simon.Derr@bull.net>
Cc: Nicolas Capit <nicolas.capit@imag.fr>, linux-kernel@vger.kernel.org,
       Paul Jackson <pj@sgi.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Paul Menage <menage@google.com>, Balbir Singh <balbir@in.ibm.com>
Subject: Re: cpuset trouble after hibernate
Message-Id: <20070915010807.b0055e7e.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0709101141180.3467@frecb006381.adech.frec.bull.fr>
References: <20070908204438.3bf03d85@localhost.localdomain>
	<Pine.LNX.4.64.0709101141180.3467@frecb006381.adech.frec.bull.fr>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007 11:45:10 +0200 (CEST) Simon Derr <Simon.Derr@bull.net> wrote:

> On Sat, 8 Sep 2007, Nicolas Capit wrote:
> 
> > Hello,
> > 
> > This is my situation:
> >   - I mounted the pseudo cpuset filesystem into /dev/cpuset
> >   - I created a cpuset named oar with my 2 cpus
> > 
> > cat /dev/cpuset/oar/cpus 
> > 0-1
> > 
> >   - Then I hibernate my computer with 'echo -n "disk" >/sys/power/state'
> >   - After reboot:
> > 
> > cat /dev/cpuset/oar/cpus 
> > 0
> > 
> > Why did I lost a cpu?
> > Is this a normal behavior???
> 
> Hi Nicolas,
> 
> I believe this is related to the fact that hibernation uses the hotplug 
> subsystem to disable all CPUs except the boot CPU.
> 
> Thus guarantee_online_cpus() is called on each cpuset and removes all 
> CPUs, except CPU 0, from all cpusets.
> 
> I'm not quite sure about if/how this should be fixed in the kernel, 
> though. Looks like a very simple user-land workaround would be enough.
> 

Yeah.  Bug, surely.  But I guess it's always been there.

What are the implications of this for cpusets-via-containers?

