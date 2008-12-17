Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753151AbYLQWYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbYLQWYP (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 17:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbYLQWXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 17:23:45 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:40454 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbYLQWXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 17:23:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=u9ZHWD4PJpre/qhTyhNWnviFTHybZCJj2b/v5iXrplMsyEAPRSciA7dtoYv7H9Lj84
         iJLGqAY0KwBl+00lE0RdPfimnNUUfwVIWvNO4o8J3/BzPenoltUCRyg0i8ryHYlSkjN1
         /UD7Q1v6U/nusAo7U4fTUoSQPxy5NK5nnCWXg=
Message-ID: <c62985530812171423x71660399va172698b1e09b7ac@mail.gmail.com>
Date: Wed, 17 Dec 2008 23:23:42 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH] ftrace: add not to regex on filtering functions
Cc: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
        "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0812171713310.4839@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.1.10.0812171713310.4839@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/17 Steven Rostedt <rostedt@goodmis.org>:
>
> The following patch is in:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
>
>    branch: tip/devel
>
>
> Steven Rostedt (1):
>      ftrace: add not to regex on filtering functions
>
> ----
>  kernel/trace/ftrace.c |   15 +++++++++++++--
>  1 files changed, 13 insertions(+), 2 deletions(-)
> ---------------------------
> commit 697732357fc9af46c5cbd865877495c9b52fb1e0
> Author: Steven Rostedt <srostedt@redhat.com>
> Date:   Wed Dec 17 15:05:36 2008 -0500
>
>    ftrace: add not to regex on filtering functions
>
>    Impact: enhancement
>
>    Ingo Molnar has asked about a way to remove items from the filter
>    lists. Currently, you can only add or replace items. The way
>    items are added to the list is through opening one of the list
>    files (set_ftrace_filter or set_ftrace_notrace) via append.
>    If the file is opened for truncate, the list is cleared.
>
>      echo spin_lock > /debug/tracing/set_ftrace_filter
>
>    The above will replace the list with only spin_lock
>
>      echo spin_lock >> /debug/tracing/set_ftrace_filter
>
>    The above will add spin_lock to the list.
>
>    Now this patch adds:
>
>      echo '!spin_lock' >> /debug/tracing/set_ftrace_filter
>
>    This will remove spin_lock from the list.
>
>    The limited glob features of these lists also can be notted.
>
>      echo '!spin_*' >> /debug/tracing/set_ftrace_filter
>
>    This will remove all functions that start with 'spin_'
>
>    Note:
>
>      echo '!spin_*' > /debug/tracing/set_ftrace_filter
>
>    will simply clear out the list (notice the '>' instead of '>>')
>


Hi Steven,

That's a nice feature!
By reading this patch, I first thought that would be better to get rid
of set_ftrace_notrace and then use
the !func to trace all functions but the func. But this way we would
loose the feature of choosing some functions
and then remove only some of them by using the ! sign.

That's good as is.
