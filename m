Return-Path: <linux-kernel-owner+w=401wt.eu-S1757212AbYFZIdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbYFZIdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 04:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbYFZIdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 04:33:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:38740 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbYFZIdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 04:33:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OudVWm17N9/iLGK3f0icz3OmHyOCLT3kcLIDScAFbd5bIHYZyLuIaW0JBbtHTfP7wy
         3Qb0bgIXaZ3OeAC40Ob29eGPaPU6njmL7b2gMnsB7he01XSHWX1rH4QmF0762g5+IqEv
         XF0Nto+tl2RfJqJ/FhuRQpG0GjZEKJR+DwJwk=
Message-ID: <ac8af0be0806260133u68a5692flab65e4bb6dcf2a13@mail.gmail.com>
Date: Thu, 26 Jun 2008 16:33:11 +0800
From: "Zhao Forrest" <forrest.zhao@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: A question about group CFS scheduling
Cc: vatsa@linux.vnet.ibm.com, mingo@elte.hu, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1214468112.2794.9.camel@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ac8af0be0806260019q45fa7285oa0fc79fb02254d28@mail.gmail.com>
	 <1214468112.2794.9.camel@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Let me explain the cgroup case (the sanest option IMHO):
>
> initially all your tasks will belong to the root cgroup, eg:
>
> assuming:
> mkdir -p /cgroup/cpu
> mount none /cgroup/cpu -t cgroup -o cpu
>
> Then the root cgroup (cgroup:/) is /cgroup/cpu/ and all tasks will be
> found in /cgroup/cpu/tasks.
>
> You can then create new groups as sibling from this root group, eg:
>
> cgroup:/foo
> cgroup:/bar
>
> They will get a weigth of 1024 by default, exactly as heavy as a nice 0
> task.
>
> That means that no matter how many tasks you stuff into foo, their
> combined cpu time will be as much as a single tasks in cgroup:/ would
> get.
>
> This is fully recursive, so you can also create:
>
> cgroup:/foo/bar and its tasks in turn will get as much combined cpu time
> as a single task in cgroup:/foo would get.
>
> In theory this should go on indefinitely, in practise we'll run into
> serious numerical issues quite quickly.
>
>
> The USER grouping basically creates a fake root and all uids (including
> 0) are its siblings. The only special case is that uid-0 (aka root) will
> get twice the weight of the others.
>

Thank you for your detailed explanation! I have one more question:
cgrouping and USER grouping is mutual exclusive, am I right? That is,
when enabling cgrouping, USER grouping need to be disabled, vice
versa.

Thanks,
Forrest
