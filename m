Return-Path: <linux-kernel-owner+w=401wt.eu-S1762885AbZAUDRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762885AbZAUDRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 22:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbZAUDQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 22:16:51 -0500
Received: from smtp-out.google.com ([216.239.33.17]:60533 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbZAUDQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 22:16:50 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=D9j5jiKW+R5FFsZgtcucvq2qzkf98wunSLzubMYG8/e6LrqOWgvHB/RPJwjut5Inq
	CFiG5wx6bKnddxFLOLJ9g==
MIME-Version: 1.0
In-Reply-To: <20090120120728.9be81131.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090109143226.b79d21b4.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830901082226h6d47053cp801dafb67b6e2bc9@mail.gmail.com>
	 <20090109153219.dd8c153d.kamezawa.hiroyu@jp.fujitsu.com>
	 <1232072445.7955.40.camel@localhost>
	 <6599ad830901191752o53926bdbve593301aeff7330f@mail.gmail.com>
	 <20090120120728.9be81131.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 20 Jan 2009 19:16:42 -0800
Message-ID: <6599ad830901201916o36e5e23bse440025618495ace@mail.gmail.com>
Subject: Re: [RFC][PATCH] NOOP cgroup subsystem
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: matthltc@us.ibm.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.76
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 7:07 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> In my understanding, "sending signal" requires some protocol/order in userland.
>
> Assume that users has to send signal in following order
>  Application A -> Application B -> Application C.....
> and may have problems sending signals in following order
>  Application B -> Application A ->.....

In a case like that, a user would have to do their own signal sending
rather than letting the "signal" subsystem handle it. The signal
subsystem is more useful for doing things like sending less-refined
signals like SIGSTOP or SIGKILL to all tasks in a cgroup.

> multilply-mounted means its own hierachy can be created per mount point ?

Yes.

> If so, signal subsystem can be used instead of noop.

Supporting mounting a subsystem in multiple different hierarchies
would pretty much involve supporting mounting a hierarchy with no
subsystems (at least in the way I envisaged it), so you wouldn't need
any subsystem in that case if you were just trying to do grouping.

Paul
