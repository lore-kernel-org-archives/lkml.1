Return-Path: <linux-kernel-owner+w=401wt.eu-S1751328AbXDFVzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328AbXDFVzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 17:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbXDFVzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 17:55:09 -0400
Received: from smtp-out.google.com ([216.239.33.17]:30254 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbXDFVzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 17:55:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=e8H2mEBSy3tonKiTKlB7Tb8zpHmZL5V29m+hfQvci049bao/YOzKUe012qO3H85Es
	AvMk+E/Hrvx3qg8CJlnWA==
Message-ID: <6599ad830704061454w1e59ffb6he8642aabac8849e5@mail.gmail.com>
Date: Fri, 6 Apr 2007 14:54:48 -0700
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, containers@lists.osdl.org,
       pj@sgi.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       mbligh@google.com, winget@google.com, rohitseth@google.com,
       "Serge E. Hallyn" <serue@us.ibm.com>, dev@sw.ru, devel@openvz.org
In-Reply-To: <20070405165752.GA13687@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070403173048.GL2456@in.ibm.com>
	 <20070403175101.GN2456@in.ibm.com>
	 <6599ad830704031049v7fad0a83q3c24211cf44d71d6@mail.gmail.com>
	 <20070404030756.GA9008@in.ibm.com>
	 <6599ad830704032104hda0c4bu7099c23a86940c76@mail.gmail.com>
	 <20070404051526.GA16562@in.ibm.com>
	 <6599ad830704040000of7f1197ica543e14d290509e@mail.gmail.com>
	 <20070404172643.GA28328@in.ibm.com>
	 <6599ad830704041157m22f62077tbc41dbc064385838@mail.gmail.com>
	 <20070405165752.GA13687@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/5/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
>
> The approach I am on currently doesnt deal with dynamically loaded
> modules ..Partly because it allows subsystem ids to be compile-time
> decided

Yes, that part is definitely a good idea, since it removes one of the
potential performance complaints that people have compared to
hard-coded pointers in a structure.

I've reworked my patches to require subsystems to be declared at compile time.

> and also init_nsproxy.ctlr_data[] can be initialised to default
> values at compile time itself.

> Ok ..by posting rcfs patches, I didn't mean to introduce a "yours" and
> "mine" rift ..honestly.  In fact you would notice that they have your
> (sole) copyright still on them! It took me just two days to convert over the
> patches to use nsproxy and come up with the rcfs patches and obviously I
> couldnt have done that without your excellent patches to start with.

OK, sorry if I came across as possessive :-) There are definitely some
great ideas in your patches, some of which I've incorporated in my
patches as you'll see when I send them out later this afternoon

>
> I am still trying to come to terms with this null groupings and how they
> would be used in real life.
>
>         - Can you list a real world use of it?

As a simple job tracking mechanism, without any other implications.

>
>         - If they are "inescapable" task groups, how does the first task enter
>           such a group, using just the filesystem interface?

Root would be able to move tasks around between containers, as normal.

>
>         - If there is no real kernel use for such groups, can this be
>           implemented in userspace (user ids, session ids etc)

Not cleanly. (Multiple jobs with the same user, session ids can be
changed by the user). Currently in the job-control system I'm working
on here, I was tagging any processes introduced in a job with a
job-unique extra gid, so we could identify which job a process was in
by looking at its group list. But that's a bit ugly.

In a more modern kernel we can just use cpusets without bothering to
make distinctions between the memory and cpus in different cpusets,
but it seems ugly to have to use a more heavyweight solution than you
really need.

In practice, this would be more of a toy/example, since anyone doing
job control probably is interested in at least some rudimentary kind
of resource tracking/control.

Paul
