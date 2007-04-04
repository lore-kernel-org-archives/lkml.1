Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbXDDXIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbXDDXIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 19:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbXDDXIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 19:08:21 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:43934 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbXDDXIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 19:08:18 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Paul Menage" <menage@google.com>
Cc: vatsa@in.ibm.com, sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, rohitseth@google.com,
       pj@sgi.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       dev@sw.ru, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 7/7] containers (V7): Container interface to nsproxy subsystem
References: <20070403171155.GK2456@in.ibm.com>
	<20070403173048.GL2456@in.ibm.com>
	<6599ad830704031030n2311bcd7hca9f34e64c66337f@mail.gmail.com>
	<20070403175101.GN2456@in.ibm.com>
	<6599ad830704031049v7fad0a83q3c24211cf44d71d6@mail.gmail.com>
	<20070404030756.GA9008@in.ibm.com>
	<6599ad830704032104hda0c4bu7099c23a86940c76@mail.gmail.com>
	<20070404051526.GA16562@in.ibm.com>
	<6599ad830704040000of7f1197ica543e14d290509e@mail.gmail.com>
	<20070404172643.GA28328@in.ibm.com>
	<6599ad830704041157m22f62077tbc41dbc064385838@mail.gmail.com>
Date: Wed, 04 Apr 2007 17:02:39 -0600
In-Reply-To: <6599ad830704041157m22f62077tbc41dbc064385838@mail.gmail.com>
	(Paul Menage's message of "Wed, 4 Apr 2007 11:57:18 -0700")
Message-ID: <m1ircb2168.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Next time I have a moment I will try and take a closer look.  However
currently these approaches feel like there is some unholy coupling going
on between different things.

In addition there appear to be some weird assumptions (an array with
one member per task_struct) in the group.  The pid limit allows
us millions of task_structs if the user wants it.   A several megabyte
array sounds like a completely unsuitable data structure.   What
is wrong with just traversing task_list at least initially?

What happened to the unix philosophy of starting with simple and
correct designs? 

Further we have several different questions that are all mixed up 
in this thread.

- What functionality do we want to provide.
- How do we want to export that functionality to user space.

You can share code by having an embedded structure instead of a magic
subsystem things have to register with, and I expect that would be
preferable.  Libraries almost always are easier to work with then
a subsystem with strict rules that doesn't give you choices.

Why do we need a subsystem id?  Do we expect any controllers to
be provided as modules?  I think the code is so in the core that
modules of any form are a questionable assumption.

.....
There is a real issue to be solved here that we can't add
controls/limits for a group of processes if we don't have a user space
interface for it.

Are the issues of building a user space interface so very hard,
and the locking so very nasty or is this a case of over engineering?

I'm inclined to the rcfs variant and using nsproxy (from what I have
seen in passing) because it is more of an exercise in minimalism, and I
am strongly inclined to be minimalistic.  The straight cpuset
derivative seems to start with everything but the kitchen sink and
then add on to it.  Which at first glance seems unhealthy.

Eric
