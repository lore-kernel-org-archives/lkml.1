Return-Path: <linux-kernel-owner+w=401wt.eu-S1752654AbXCIWJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbXCIWJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 17:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbXCIWJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 17:09:53 -0500
Received: from smtp-out.google.com ([216.239.33.17]:42670 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbXCIWJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 17:09:52 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=lTP+G46oWUCUe4+teCqtBqmUWeaFig9RrPuiUrgnmzglPA7/iio5h3KQmG0ymEolZ
	StNYpPhn7439oz+S870LQ==
Message-ID: <6599ad830703091409s3d233829gb8f0afbfd2883b15@mail.gmail.com>
Date: Fri, 9 Mar 2007 14:09:35 -0800
From: "Paul Menage" <menage@google.com>
To: vatsa@in.ibm.com
Subject: Re: [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, ebiederm@xmission.com,
       sam@vilain.net, akpm@linux-foundation.org, pj@sgi.com, dev@sw.ru,
       xemul@sw.ru, containers@lists.osdl.org, winget@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <20070309163430.GN6504@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070301133543.GK15509@in.ibm.com>
	 <6599ad830703061832w49179e75q1dd975369ba8ef39@mail.gmail.com>
	 <20070307173031.GC2336@in.ibm.com>
	 <20070307174346.GA19521@sergelap.austin.ibm.com>
	 <20070307180055.GC17151@in.ibm.com>
	 <20070307205846.GB7010@sergelap.austin.ibm.com>
	 <6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com>
	 <20070309163430.GN6504@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/9/07, Srivatsa Vaddagiri <vatsa@in.ibm.com> wrote:
>
> 1. What is the fundamental unit over which resource-management is
> applied? Individual tasks or individual containers?
>
>         /me thinks latter.

Yes

> In which case, it makes sense to stick
>         resource control information in the container somewhere.

Yes, that's what all my patches have been doing.

> 2. Regarding space savings, if 100 tasks are in a container (I dont know
>    what is a typical number) -and- lets say that all tasks are to share
>    the same resource allocation (which seems to be natural), then having
>    a 'struct container_group *' pointer in each task_struct seems to be not
>    very efficient (simply because we dont need that task-level granularity of
>    managing resource allocation).

I think you should re-read my patches.

Previously, each task had N pointers, one for its container in each
potential hierarchy. The container_group concept means that each task
has 1 pointer, to a set of container pointers (one per hierarchy)
shared by all tasks that have exactly the same set of containers (in
the various different hierarchies).

It doesn't give task-level granularity of resource management (unless
you create a separate container for each task), it just gives a space
saving.

>
> 3. This next leads me to think that 'tasks' file in each directory doesnt make
>    sense for containers. In fact it can lend itself to error situations (by
>    administrator/script mistake) when some tasks of a container are in one
>    resource class while others are in a different class.
>
>         Instead, from a containers pov, it may be usefull to write
>         a 'container id' (if such a thing exists) into the tasks file
>         which will move all the tasks of the container into
>         the new resource class. This is the same requirement we
>         discussed long back of moving all threads of a process into new
>         resource class.

I think you need to give a more concrete example and use case of what
you're trying to propose here. I don't really see what advantage
you're getting.

Paul
