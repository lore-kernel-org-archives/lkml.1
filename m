Return-Path: <linux-kernel-owner+w=401wt.eu-S1030354AbXCHJKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030354AbXCHJKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 04:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030380AbXCHJKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 04:10:41 -0500
Received: from smtp-out.google.com ([216.239.33.17]:38730 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030354AbXCHJKh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 04:10:37 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=WcwQAkSyyBA2nGKyutLHWX3P3BjLZqmcLYYnHZS773IlKNGuAHZukIWQKKWy8j6rS
	ioBN2fyN5Qn0JEp1lmDTw==
Message-ID: <6599ad830703080110i33405501tb12bf8e58bf829c9@mail.gmail.com>
Date: Thu, 8 Mar 2007 01:10:27 -0800
From: "Paul Menage" <menage@google.com>
To: "Sam Vilain" <sam@vilain.net>
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Cc: "Srivatsa Vaddagiri" <vatsa@in.ibm.com>, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, dev@sw.ru, pj@sgi.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, winget@google.com,
       containers@lists.osdl.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       akpm@linux-foundation.org
In-Reply-To: <45EF83CB.9080903@vilain.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20070301133543.GK15509@in.ibm.com>
	 <m1odn4bs6n.fsf@ebiederm.dsl.xmission.com>
	 <6599ad830703071518y715ecdb2y33752a6e25b5ecdb@mail.gmail.com>
	 <45EF5A62.8000103@vilain.net>
	 <6599ad830703071642n69bbd801n6114fa6f9e60a168@mail.gmail.com>
	 <45EF5E71.7090101@vilain.net>
	 <6599ad830703071658q60466dd8hd18a1eab9bc17535@mail.gmail.com>
	 <45EF793C.1000700@vilain.net>
	 <6599ad830703071857yf711921ja3440c4276bbe58e@mail.gmail.com>
	 <45EF83CB.9080903@vilain.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, Sam Vilain <sam@vilain.net> wrote:
>
> Ok, they share this characteristic with namespaces: that they group
> processes.  So, they conceptually hang off task_struct.  But we put them
> on ns_proxy because we've got this vague notion that things might be
> better that way.

Remember that I'm not the one pushing to move them into ns_proxy.
These patches are all Srivatsa's work. Despite that fact that they say
"Signed-off-by: Paul Menage", I'd never seen them before they were
posted to LKML, and I'm not sure that they're the right approach.
(Although some form of unification might be good).

>
> >> about this you still insist on calling this sub-system specific stuff
> >> the "container",
> >>
> > Uh, no. I'm trying to call a *grouping* of processes a container.
> >
>
> Ok, so is this going to supplant the namespaces too?

I don't know. It would be nice to have a single object hanging off the
task struct that contains all the various grouping pointers. Having
something that was flexible enough to handle all the required
behaviours, or else allowing completely different behaviours for
different subsets of that structure, could be the fiddly bit.

See my expanded reply to Eric' earlier post for a possible way of
unifying them, and simplifying the nsproxy and container.c code in the
process.

>
>   - resource groups (I get a strange feeling of déjà vú there)

Resource groups isn't a terrible name for them (although I'd be
wondering whether the BeanCounters folks would object :-) ) but the
intention is that they're more generic than purely for resource
accounting. (E.g. see my other email where I suggested that things
like task->mempolicy and task->user could potentially be treated in
the same way)

Task Group is a good name, except for the fact that it's too easily
confused with process group.

>
> And do we bother changing IPC namespaces or let that one slide?
>

I think that "namespace" is a fine term for the IPC id
virtualization/restriction that ipc_ns provides. (Unless I'm totally
misunderstanding the concept).

Paul
