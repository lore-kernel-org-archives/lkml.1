Return-Path: <linux-kernel-owner+w=401wt.eu-S2992643AbXCGV7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992643AbXCGV7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 16:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965693AbXCGV7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 16:59:31 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49809 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965692AbXCGV7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 16:59:30 -0500
Date: Wed, 7 Mar 2007 15:59:19 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Paul Menage <menage@google.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, ebiederm@xmission.com,
       sam@vilain.net, akpm@linux-foundation.org, pj@sgi.com, dev@sw.ru,
       xemul@sw.ru, containers@lists.osdl.org, winget@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070307215919.GA2110@sergelap.austin.ibm.com>
References: <20070301133543.GK15509@in.ibm.com> <6599ad830703061832w49179e75q1dd975369ba8ef39@mail.gmail.com> <20070307173031.GC2336@in.ibm.com> <20070307174346.GA19521@sergelap.austin.ibm.com> <20070307180055.GC17151@in.ibm.com> <20070307205846.GB7010@sergelap.austin.ibm.com> <6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Menage (menage@google.com):
> On 3/7/07, Serge E. Hallyn <serue@us.ibm.com> wrote:
> >
> >All that being said, if it were going to save space without overly
> >complicating things I'm actually not opposed to using nsproxy, but it
> 
> If space-saving is the main issue, then the latest version of my

Space saving was the only reason for nsproxy to exist.

Now of course it also provides the teensiest reduction in # instructions
since every clone results in just one reference count inc for the
nsproxy rather than one for each namespace.

> containers patches uses just a single pointer in the task_struct, and
> all tasks in the same set of containers (across all hierarchies) will
> share a single container_group object, which holds the actual pointers
> to container state.

Yes, that's why this consolidation doesn't make sense to me.

Especially considering again that we will now have nsproxies pointing to
containers pointing to... nsproxies.

> Effectively, container_group is to container as nsproxy is to namespace.
> 
> Paul
