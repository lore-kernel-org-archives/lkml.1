Return-Path: <linux-kernel-owner+w=401wt.eu-S1030499AbXBTWT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030499AbXBTWT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 17:19:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030501AbXBTWTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 17:19:54 -0500
Received: from smtp-out.google.com ([216.239.33.17]:58248 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030499AbXBTWTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 17:19:52 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=rualR6ZOVmeiKkLyGDVEp8mXKFuRY1X/A72sQql2P4Rc7jhy6vfLGmA9g9Ul2mcRv
	I4zbWI9gzvHOVLqAM5gRQ==
Message-ID: <6599ad830702201419n2fe02661y58f09f7dc8d23d88@mail.gmail.com>
Date: Tue, 20 Feb 2007 14:19:39 -0800
From: "Paul Menage" <menage@google.com>
To: "Sam Vilain" <sam@vilain.net>
Subject: Re: [PATCH 0/7] containers (V7): Generic Process Containers
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, akpm@osdl.org, pj@sgi.com,
       sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       vatsa@in.ibm.com, containers@lists.osdl.org, winget@google.com,
       rohitseth@google.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <45DB6F07.8080409@vilain.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070212081521.808338000@menage.corp.google.com>
	 <45D0EC68.9090009@vilain.net>
	 <6599ad830702121515p10bc1b58kf1d29367b9b18016@mail.gmail.com>
	 <m1wt2c4ttj.fsf@ebiederm.dsl.xmission.com>
	 <6599ad830702200955l10f3c71aucff1d4b815e1a1e7@mail.gmail.com>
	 <45DB6F07.8080409@vilain.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/20/07, Sam Vilain <sam@vilain.net> wrote:
>
> The term "segregated group of processes" is too vague.  Segregated for
> what?  What is the kernel supposed to do with this information?

The generic part of the kernel just keeps track of the fact that
they're segregated (and their children, etc).

It's the clients of this subsystem (virtual servers, resource
controllers) that can decide to give different per-process behaviour
based on the membership of various groups.

> Did you like the names I came up with in my original reply?
>
>  - CPUset namespace for CPU partitioning
>  - Resource namespaces:
>    - cpusched namespace for CPU
>    - ulimit namespace for memory
>    - quota namespace for disk space
>    - io namespace for disk activity
>    - etc

This is a strange abuse of the term "namespace".
http://en.wikipedia.org/wiki/Namespace_%28computer_science%29

For the virtual server work that you're doing, namespace is a good term:

pids name processes, hence a pid namespace lets you have multiple
distinct mappings from pids to processes
filenames name files, so a filename (or mount) namespace lets you have
multiple distinct mappings from filenames to files.

For resource QoS control, it doesn't really make sense to talk about
namespaces. We're not virtualizing resources to rename them for
different virtual servers, we're limiting the quality of access to the
resources.

But the semantics of the term "namespace" notwithstanding, you're
equating a virtual server namespace (pid, ipc, uts, mounts, etc) with
a resource controller (memory, I/O, etc) in terms of their place in a
hierarchy, which is something I agree with. All of these subsystems
can be considered to be units that can be associated with groups of
processes; the ultimate grouping of processes is something that we're
both ultimately referring to as a container.

>
> Maybe what's missing is a set of helper macros/functions that assist
> with writing new namespaces.

That's pretty much what my containers patch does - provides a generic
way to associate state (what you're referring to as a namespace) with
groups of processes and a consistent user-space API for manipulating
them.

Paul
