Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbZGBQQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbZGBQQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 12:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbZGBQPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 12:15:55 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:54149 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZGBQPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 12:15:55 -0400
Date: Thu, 2 Jul 2009 11:15:49 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH][BUGFIX] cgroups: fix pid namespace bug
Message-ID: <20090702161548.GA13383@us.ibm.com>
References: <4A4C0C60.4050106@cn.fujitsu.com> <6599ad830907011836x5eccc83eyc896a67295a6486d@mail.gmail.com> <4A4C18D5.7020806@cn.fujitsu.com> <6599ad830907011920r44df4022p53808b574da4a886@mail.gmail.com> <4A4C1B33.2030002@cn.fujitsu.com> <20090702132659.GA8051@us.ibm.com> <6599ad830907020843l7ce75abfq3e78b8f67a407ab9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830907020843l7ce75abfq3e78b8f67a407ab9@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Menage (menage@google.com):
> On Thu, Jul 2, 2009 at 6:26 AM, Serge E. Hallyn<serue@us.ibm.com> wrote:
> > Quoting Li Zefan (lizf@cn.fujitsu.com):
> >> Paul Menage wrote:
> >> > On Wed, Jul 1, 2009 at 7:17 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
> >> >> But I guess we are going to fix the bug for 2.6.31? So is it ok to
> >> >> merge a new feature 'cgroup.procs' together into 2.6.31?
> >> >>
> >> >
> >> > Does this bug really need to be fixed for 2.6.31? I didn't think that
> >> > the namespace support in mainline was robust enough yet for people to
> >> > use them for virtual servers in production environments.
> >
> > I don't know where the bar is for 'production environments', but I'd
> > have to claim that pid namespaces are there...
> 
> Well, pid namespaces are marked as experimental, as are user
> namespaces (and were described as "very incomplete" a few months

incomplete (due to signaling issues which have mostly been resolved)
but stable and usable.

user namespace are a completely different story :)

> back). Pid namespaces are useful for process migration (which is still
> under development) or virtual servers (for which user namespaces are
> pretty much essential). So I'm not sure quite what you'd use pid
> namespaces for yet.

You don't need user namespaces to use pid namespaces for virtual
servers (depending on your use).

Now the fact remains this is a hard to trigger bug which doesn't
corrupt the kernel, and - to take back what I said earlier - userspace
can work around it by simply freezing the cgroup before reading its
tasks file.

So I guess I can go either way...  If Li's patch were more complicated
I'd definately be for waiting.  But I do object to the general process
of making a fix of a pretty bad bag depend on an unrelated new feature!

-serge
