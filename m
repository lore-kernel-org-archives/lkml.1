Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbZGUT5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbZGUT5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 15:57:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755658AbZGUT53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 15:57:29 -0400
Received: from smtp-out.google.com ([216.239.45.13]:40253 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748AbZGUT52 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 15:57:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=bzGPANHEdwNaU6kFC+gSavONKV+FBLKv2m9Bd4pjrQJiMi0a55aFRGyAqdx888CTs
	1yTcl7B1d5K/F7iH5WJKQ==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0907211250530.10356@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0907171559290.30600@chino.kir.corp.google.com>
	 <6599ad830907201452h5b57a444mf4be96e194cb737@mail.gmail.com>
	 <20090721161319.2ABD.A69D9226@jp.fujitsu.com>
	 <6599ad830907210906tf81842ds897012bbf0e5606d@mail.gmail.com>
	 <alpine.DEB.2.00.0907211250530.10356@chino.kir.corp.google.com>
Date: Tue, 21 Jul 2009 12:57:23 -0700
Message-ID: <6599ad830907211257m6c8d6123g7b36d879913367a0@mail.gmail.com>
Subject: Re: [PATCH] copy over oom_adj value at fork time
From: Paul Menage <menage@google.com>
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mel@csn.ul.ie, npiggin@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 12:54 PM, David Rientjes<rientjes@google.com> wrote:
>
> That's exactly the scenario my patches were addressing, actually.  It was
> possible to get an oom killer livelock if a thread was constantly chosen
> when sharing memory with an OOM_DISABLE task.  So your example is a recipe
> for livelock without my patches since the parent is OOM_DISABLE and the
> child is not, yet they share an ->mm so neither can be killed.  If the
> child is repeatedly chosen prior to execve, no memory freeing is possible
> unless another task happens to exceed the badness score of the child.


Agreed, but the same livelock can be fixed in ways that don't break
the API. (E.g. check for the victim being OOM_DISABLED in
select_bad_process() when we find a new "worst" candidate).

Paul
