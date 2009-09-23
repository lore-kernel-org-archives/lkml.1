Return-Path: <linux-kernel-owner+w=401wt.eu-S1751782AbZIWP0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751782AbZIWP0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 11:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbZIWP0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 11:26:16 -0400
Received: from mail.gmx.net ([213.165.64.20]:46634 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751252AbZIWP0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 11:26:16 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+BsOUIjGuBFFgig5nyLEdHNOrf5MIfeAwGBpbkdL
	1QAeOWjs+aAO4C
Subject: Re: [patch] Re: [perf] Finding uninstalled modules Was Re: mailing
 list for trace users
From: Mike Galbraith <efault@gmx.de>
To: Avi Kivity <avi@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, rostedt@goodmis.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Masami Hiramatsu <mhiramat@redhat.com>
In-Reply-To: <4ABA3A37.2070108@redhat.com>
References: <1253132182.20020.242.camel@gandalf.stny.rr.com>
	 <4AB89520.2050900@redhat.com> <1253618894.13917.18.camel@marge.simson.net>
	 <4AB8B65F.7030602@redhat.com> <1253620041.13917.24.camel@marge.simson.net>
	 <4AB8BA37.4010305@redhat.com> <20090922201746.GH5216@ghostprotocols.net>
	 <4AB9DCC8.5050603@redhat.com> <1253697658.11461.36.camel@marge.simson.net>
	 <4AB9F08E.1020106@redhat.com> <1253705515.7835.41.camel@marge.simson.net>
	 <4ABA1B75.7040900@redhat.com>  <4ABA1E3B.40800@redhat.com>
	 <1253713800.7816.15.camel@marge.simson.net>  <4ABA2A0B.1010103@redhat.com>
	 <1253714972.7816.23.camel@marge.simson.net>  <4ABA3321.9090503@redhat.com>
	 <1253717548.7816.34.camel@marge.simson.net>  <4ABA3732.3040907@redhat.com>
	 <1253718323.7816.42.camel@marge.simson.net>  <4ABA3A37.2070108@redhat.com>
Content-Type: text/plain
Date: Wed, 23 Sep 2009 17:26:16 +0200
Message-Id: <1253719576.7816.53.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-23 at 18:09 +0300, Avi Kivity wrote:
> On 09/23/2009 06:05 PM, Mike Galbraith wrote:
> >
> >> Well, you don't need to do anything to open a file from cwd: that's the
> >> default.  You need to actively prepend /lib/modules/blah to get it to
> >> load from the correct location.  What I don't understand is why it is
> >> only hitting me (esp. as it used to work).
> >>      
> > If your modules.dep, always was missing the /lib/modules/blah bit, it
> > never worked for you.  I wrote the thing with the rash assumption that
> > it always contained full path like mine does :)
> >
> >    
> 
> Ah, changed there, I missed that part earlier, sorry.  So it's probably 
> a change in modules.dep generation instead of tools/perf.
> 
> > So, I just need to check whether it's full path or not, prepend or take
> > the path as is, and hope there aren't several other ways to get screwed
> > up by modules.dep content.
> >    
> 
> Maybe we should fix that then (though I prefer relative paths myself).

I'll do the check for relative vs full thing, and a bail noisily if it
finds something else.  (later i guess, wife is giving me the evil eye;)

> > Too bad the kernel doesn't store the path in /sys/modules/bla/path.
> > That would be nicer than rummaging around in a mutable file.
> >    
> 
> But then you rely on a running kernel.  Be nice to be able to ship 
> perf.data.

Long term, all pertinent data should go into a shippable perf.data.

	-Mike

