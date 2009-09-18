Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbZIRO7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbZIRO7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 10:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbZIRO7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 10:59:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456AbZIRO7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 10:59:39 -0400
Subject: Re: kernel panic - not syncing: out of memory and no killable
 processes
From: Eric Paris <eparis@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Greg KH <greg@kroah.com>,
       linux-hotplug@vger.kernel.org
In-Reply-To: <alpine.DEB.1.00.0909171446230.22063@chino.kir.corp.google.com>
References: <1253158603.5213.204.camel@dhcp231-106.rdu.redhat.com>
	 <1253191435.5213.209.camel@dhcp231-106.rdu.redhat.com>
	 <alpine.DEB.1.00.0909171326340.31112@chino.kir.corp.google.com>
	 <1253219756.5213.348.camel@dhcp231-106.rdu.redhat.com>
	 <1253221309.5213.350.camel@dhcp231-106.rdu.redhat.com>
	 <1253222149.5213.352.camel@dhcp231-106.rdu.redhat.com>
	 <alpine.DEB.1.00.0909171417020.19006@chino.kir.corp.google.com>
	 <1253223119.5213.359.camel@dhcp231-106.rdu.redhat.com>
	 <alpine.DEB.1.00.0909171446230.22063@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Sep 2009 10:58:43 -0400
Message-Id: <1253285923.30531.17.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-17 at 14:59 -0700, David Rientjes wrote:
> On Thu, 17 Sep 2009, Eric Paris wrote:
> 
> > Absolutely 100% udevd related.  It always pops right when udev starts.
> > Every time.  I don't know how to get that to come out on the serial
> > port, you only get to see the kernel messages (although there is nothing
> > on the screen other than "Starting udev"
> > 
> > Reverting 3f2aa307c4d26b4ed6509d0a79e8254c9e07e921 causes the problem to
> > go away.  I now am running a 79b520e87e kernel + your patch (adding
> > console_verbose()) + reverting 3f2aa307c4d2 and it seems to be working.
> > 
> 
> Isolating udevd down to an interactivity scheduling change isn't _that_ 
> bizarre.  I think the setting of UDEVD_PRIORITY is already mostly 
> arbitrary anyway and it'll allow 192 children on your 512M machine by 
> default unless you changed UDEVD_MAX_CHILDS for uid 0.
> 
> The default timeout for idle workers is 3 seconds, which may just happen 
> to be long enough to panic your machine because of low memory.  If that's 
> the case, I don't believe that it's a scheduler issue but rather a root 
> abuse of setting all udevd threads to be OOM_DISABLE.
> 
> What is your udevd --version?  The latest is udev-146 released last month.

145

Let me try and clone the vm some I don't break my reproducer.  I'll see
if adding more memory fixes it.  Doesn't look like Fedora has built a
-146 yet, I'll see if I can get one of those as well.

udev bug, configuration issue, whatever, or not, it's a regression that
I used to be able to boot and updating my kernel leaves me unable to
boot.  I think we all agree when 512M of memory isn't enough to boot to
runlevel 3 we've got a problem   :)

-Eric


