Return-Path: <linux-kernel-owner+w=401wt.eu-S2992821AbXCIBGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992821AbXCIBGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 20:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992851AbXCIBGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 20:06:33 -0500
Received: from MAIL.13thfloor.at ([213.145.232.33]:40851 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992821AbXCIBGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 20:06:32 -0500
Date: Fri, 9 Mar 2007 02:06:28 +0100
From: Herbert Poetzl <herbert@13thfloor.at>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Matt Helsley <matthltc@us.ibm.com>, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, pj@sgi.com,
       winget@google.com, containers@lists.osdl.org,
       Paul Menage <menage@google.com>, akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070309010628.GE4506@MAIL.13thfloor.at>
Mail-Followup-To: "Eric W. Biederman" <ebiederm@xmission.com>,
	Matt Helsley <matthltc@us.ibm.com>, ckrm-tech@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, xemul@sw.ru, pj@sgi.com,
	winget@google.com, containers@lists.osdl.org,
	Paul Menage <menage@google.com>, akpm@linux-foundation.org
References: <6599ad830703071518y715ecdb2y33752a6e25b5ecdb@mail.gmail.com> <45EF5A62.8000103@vilain.net> <6599ad830703071642n69bbd801n6114fa6f9e60a168@mail.gmail.com> <45EF5E71.7090101@vilain.net> <6599ad830703071658q60466dd8hd18a1eab9bc17535@mail.gmail.com> <45EF793C.1000700@vilain.net> <6599ad830703071857yf711921ja3440c4276bbe58e@mail.gmail.com> <45EF83CB.9080903@vilain.net> <1173334209.13172.61.camel@localhost.localdomain> <m11wk08c9h.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11wk08c9h.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 11:44:58PM -0700, Eric W. Biederman wrote:
> Matt Helsley <matthltc@us.ibm.com> writes:
> 
> > On Thu, 2007-03-08 at 16:32 +-1300, Sam Vilain wrote:
> >
> > +ADw-snip+AD4
> >
> > +AD4 Kirill, 06032418:36+-03:
> > +AD4 +AD4 I propose to use +ACI-namespace+ACI naming.
> > +AD4 +AD4 1. This is already used in fs.
> > +AD4 +AD4 2. This is what IMHO suites at least OpenVZ/Eric
> > +AD4 +AD4 3. it has good acronym +ACI-ns+ACI.
> > +AD4 
> > +AD4 Right.  So, now I'll also throw into the mix:
> > +AD4 
> > +AD4   - resource groups (I get a strange feeling of d+AOk-j+AOA v+APo there)
> >
> > +ADw-offtopic+AD4
> > Re: d+AOk-j+AOA v+APo: yes+ACE
> >
> > It's like that Star Trek episode ... except we can't agree on the name
> > of the impossible particle we will invent which solves all our problems.
> > +ADw-/offtopic+AD4
> >
> > At the risk of prolonging the agony I hate to ask: are all of these
> > groupings really concerned with +ACI-resources+ACI?
> >
> > +AD4   - supply chains (think supply and demand)
> > +AD4   - accounting classes
> >
> > CKRM's use of the term +ACI-class+ACI drew negative comments from Paul Jackson
> > and Andrew Morton about this time last year. That led to my suggestion
> > of +ACI-Resource Groups+ACI. Unless they've changed their minds...
> >
> > +AD4 Do any of those sound remotely close?  If not, your turn :)
> >
> > I'll butt in here: task groups? task sets? confuselets? +ADs)
> 
> Generically we can use subsystem now for the individual pieces without
> confusing anyone.
> 
> I really don't much care as long as we don't start redefining
> container as something else.  I think the IBM guys took it from
> solaris originally which seems to define a zone as a set of
> isolated processes (for us all separate namespaces).  And a container
> as a set of as a zone that uses resource control.  Not exactly how
> we have been using the term but close enough not to confuse someone.
> 
> As long as we don't go calling the individual subsystems or the
> process groups they need to function a container I really don't care.
> 
> I just know that if we use container for just the subsystem level
> it makes effective communication impossible, and code reviews
> essentially impossible.  As the description says one thing the
> reviewer reads it as another and then the patch does not match
> the description.  Leading to NAKs.
> 
> Resource groups at least for subset of subsystems that aren't
> namespaces sounds reasonable.  Heck resource group, resource
> controller, resource subsystem, resource just about anything seems
> sane to me.
> 
> The important part is that we find a vocabulary without doubly
> defined words so we can communicate and a small common set we can
> agree on so people can work on and implement the individual
> resource controllers/groups, and get the individual pieces merged
> as they are reading.

from my personal PoV the following would be fine:

 spaces (for the various 'spaces')

  - similar enough to the old namespace
  - can be easily used with prefix/postfix
    like in pid_space, mnt_space, uts_space etc
  - AFAIK, it is not used yet for anything else

 container (for resource accounting/limits)

  - has the 'containment' principle built in :)
  - is used in similar ways in other solutions
  - sounds similar to context (easy to associate)

note: I'm also fine with other names, as long as
we find some useable vocabulary soon, as the
different terms start confusing me on a regular
basis, and we do not go for already used names,
which would clash with Linux-VServer or OpenVZ
terminology (which would confuse the hell out of
the end-users :)

best,
Herbert

> Eric
> _______________________________________________
> Containers mailing list
> Containers@lists.osdl.org
> https://lists.osdl.org/mailman/listinfo/containers
