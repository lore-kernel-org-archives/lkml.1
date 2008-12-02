Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbYLBTqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbYLBTqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 14:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbYLBTqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 14:46:22 -0500
Received: from relay4.ptmail.sapo.pt ([212.55.154.24]:56254 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754413AbYLBTqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 14:46:21 -0500
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Tue, 2 Dec 2008 19:46:10 +0000
From: Luis Henriques <henrix@sapo.pt>
To: Avi Kivity <avi@redhat.com>
Cc: Steven Rostedt <srostedt@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] kvm crashes in 2.6.28-rc6-00007-ged31348
Message-ID: <20081202194610.GA4864@hades>
References: <20081130193401.GA7690@hades> <4932F59D.2060002@redhat.com> <20081130203833.GA14903@hades> <4932FB47.6090300@redhat.com> <20081130210406.GA17952@hades> <493528D8.8010904@redhat.com> <20081202190914.GA12115@hades>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081202190914.GA12115@hades>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I am CC'ing to Steven Rostedt since he might be interested on this)

On Tue, Dec 02, 2008 at 07:09:14PM +0000, Luis Henriques wrote:
> On Tue, Dec 02, 2008 at 02:23:52PM +0200, Avi Kivity wrote:
> > Luis Henriques wrote:
> >> On Sun, Nov 30, 2008 at 10:44:55PM +0200, Avi Kivity wrote:
> >>   
> >>> Luis Henriques wrote:
> >>>     
> >>>> No, I was not able to reproduce the issue.  Please let me know if you need some
> >>>> more information on my system (.config, for instance).
> >>>>         
> >>> Were you using some other virtualization product?  Were you running   
> >>> suspend/resume?
> >>>     
> >>
> >> No for both questions.  However, I had compiled support for suspend (not sure if
> >> this is what you mean by "running suspend/resume") - This is a feature I used
> >> only once or twice...
> >>   
> >
> > The underlying problem is that an svm instruction has been executed, but  
> > svm is disabled.  Since kvm enables svm unconditionally on all  
> > processors on startup, there are only a few paths that can potentially  
> > trigger this:
> >
> > - another virtualization module turned svm off
> > - cpu hotadd/hotremove (suspend/resume triggers this)
> > - something did a read-modify-write cycle on cr4 (which contains the svm  
> > enable bit) while kvm enabled that bit
> > - core was turned off (does linux power management do that?)
> >
> > Anything ring a bell?
> 
> Ok, I am not sure but there is a possibility of having the vboxdrv driver
> loaded. _But_ I was not using, i.e., I do not use VirtualBox.  In my
> attempts to reproduce the issue, I tried to load this module but, unfortunatly,
> my distro has this package broken ATM (err... in fact, the problem is not the
> distro but me - I am using an unstable version).
> 
> vboxdrv could be a problem if I was using it, but I believe it shouldn't cause
> this if it is not being used... but it's just a guess.

I have some other information to had to my previous email.  However, I do not
know whether it is related with my first bug report.

It looks like ftrace may stop the CPUs in some situations and I have been
playing with ftrace for some time.  So, here's what I just did:  started ftrace
with function tracer and then started kvm.  I got ugly crashes and apparently
quite easy to reproduce (I get complete freeze or immediate reboot).

I did not investigated this issue and, again, it may not be related with my
initial report but there's definitely something wrong here, right?

(just to refresh, I am using 2.6.28-rc6-00007-ged31348 in x86_64 machine)

-- 
Luis Henriques

