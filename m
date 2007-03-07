Return-Path: <linux-kernel-owner+w=401wt.eu-S1422916AbXCGRcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422916AbXCGRcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422850AbXCGRcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:32:20 -0500
Received: from smtp-out.google.com ([216.239.45.13]:33985 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422897AbXCGRcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:32:15 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=wsKxGhRvUVk6lfTJzz5FxXFHXz/JJgmm8sZ0oCAVRkRHXGCp/KunV1onrgEX8Y+fE
	OYUXCJQlD/OFfzwTtWX5A==
Message-ID: <6599ad830703070929r1fa9629cjef1570b461e2b77@mail.gmail.com>
Date: Wed, 7 Mar 2007 09:29:12 -0800
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com
Subject: Re: [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Cc: ebiederm@xmission.com, sam@vilain.net, akpm@linux-foundation.org,
       pj@sgi.com, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       containers@lists.osdl.org, winget@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20070307173031.GC2336@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070301133543.GK15509@in.ibm.com>
	 <6599ad830703061832w49179e75q1dd975369ba8ef39@mail.gmail.com>
	 <20070307173031.GC2336@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
>
> > - when you do sys_unshare() or a clone that creates new namespaces,
> > then the task (or its child) will get a new nsproxy that has the rcfs
> > subsystem state associated with the old nsproxy, and one or more
> > namespace pointers cloned to point to new namespaces. So this means
> > that the nsproxy for the task is no longer the nsproxy associated with
> > any directory in rcfs. (So the task will disappear from any "tasks"
> > file in rcfs?)
>
> it "should" disappear yes, although I haven't carefully studied the
> unshare requirements yet.

That seems bad. With the current way you're doing it, if I mount
hierarchies A and B on /mnt/A and /mnt/B, then initially all tasks are
in /mnt/A/tasks and /mnt/B/tasks. If I then create /mnt/A/foo and move
a process into it, that process disappears from /mnt/B/tasks, since
its nsproxy no longer matches the nsproxy of B's root container. Or am
I missing something?

Paul
