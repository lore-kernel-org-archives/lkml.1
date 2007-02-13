Return-Path: <linux-kernel-owner+w=401wt.eu-S932952AbXBMBrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952AbXBMBrm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 20:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933028AbXBMBrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 20:47:42 -0500
Received: from smtp-out.google.com ([216.239.45.13]:35365 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932952AbXBMBrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 20:47:41 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=xyOdstvlNxyMd+wi0Lb3x260IJogblJJpYSk47TQat1QRwHEwW8iR2YeCLMJFXGcT
	ujbk9b0KFUqy2AKy14tZg==
Message-ID: <6599ad830702121747s2b760f30v5c054a15801ca973@mail.gmail.com>
Date: Mon, 12 Feb 2007 17:47:20 -0800
From: "Paul Menage" <menage@google.com>
To: "Sam Vilain" <sam@vilain.net>
Subject: Re: [ckrm-tech] [PATCH 0/7] containers (V7): Generic Process Containers
Cc: vatsa@in.ibm.com, sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, containers@lists.osdl.org,
       pj@sgi.com, ebiederm@xmission.com, winget@google.com,
       rohitseth@google.com, serue@us.ibm.com, dev@sw.ru
In-Reply-To: <45D110A3.1010502@vilain.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070212081521.808338000@menage.corp.google.com>
	 <45D0EC68.9090009@vilain.net>
	 <6599ad830702121515p10bc1b58kf1d29367b9b18016@mail.gmail.com>
	 <45D1068D.4060906@vilain.net>
	 <6599ad830702121642w80c53ddud3c77c13af99d2b7@mail.gmail.com>
	 <45D110A3.1010502@vilain.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/12/07, Sam Vilain <sam@vilain.net> wrote:
>
> Not every module, you just make them on sensible, planned groupings.
> The danger is that the "container" group becomes a fallback grouping for
> things when people can't be bothered thinking about it properly, and
> everything including the kitchen sink gets thrown in.  Then later you
> find a real use case where you don't want them together, but it's too
> late because it's already a part of the official API.

This paragraph seems to have a contradiction - first you say that
modules should use "planned groupings", then you complain that modules
using generic containers will find that they can't separate from other
modules "because they're part of an official API".

On the contrary - a module that's written over generic containers can
be combined with other such modules in the same groupings, or used in
different groupings, depending on what the user desires. This is
discussed in some detail in Documentation/containers.txt in patch 3 of
my patchset.

My patchset doesn't try to make all modules use the same *grouping*,
it tries to make them use the same *abstraction* (and hence share
code), but allows them to easily use different groupings just by
binding modules to different hierarchies.

>
> > As an example, the CPU accounting patch that in included in my patch
> > set as an illustration of a simple resource monitoring module is just
> > 250 lines, almost entirely in one file; if it also had to handle
> > associating tasks together into groups and presenting a filesystem
> > interface to the user it would be far larger and would have a much
> > bigger footprint on the kernel.
> >
>
> It's also less flexible.  What if I want to do CPU accounting on some
> other boundaries than the "virtual server" a process is a part of?

No problem - that's why there are multiple hierarchies available. You
can mount the CPU accounting on one hierarchy, the virtual servers on
a different hierarchy, and they have completely independent mappings
from processes to containers - essentially parallel trees of
containers.

Paul
