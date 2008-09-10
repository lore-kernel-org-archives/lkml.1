Return-Path: <linux-kernel-owner+w=401wt.eu-S1754369AbYIJXbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbYIJXbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 19:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbYIJXb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 19:31:29 -0400
Received: from smtp-out.google.com ([216.239.33.17]:6873 "EHLO
	smtp-out3.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751563AbYIJXb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 19:31:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=VUnLzEWO0A9kJLHeCN65jkO9vyEsA5MJuJuc+Hac5/vQrjte4FyEJ2NuYMd47nIdy
	WIj0fcjWBqCTLhf9urf4A==
Message-ID: <6599ad830809101631q51371f75w2ab9f73ef2414f90@mail.gmail.com>
Date: Wed, 10 Sep 2008 16:31:10 -0700
From: "Paul Menage" <menage@google.com>
To: "Thomas Graf" <tgraf@suug.ch>
Subject: Re: [PATCH 1/2] Traffic control cgroups subsystem
Cc: "Ranjit Manomohan" <ranjitm@google.com>, davem@davemloft.net,
       akpm@linux-foundation.org, kaber@trash.net, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20080910232413.GJ20815@postel.suug.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0809101040280.7050@ranjit.corp.google.com>
	 <20080910220115.GH20815@postel.suug.ch>
	 <166fe7950809101556q61cb7e30m2d5e758304618f61@mail.gmail.com>
	 <6599ad830809101604o71b2fb82k2aca1eb0fd8ab6d8@mail.gmail.com>
	 <20080910232413.GJ20815@postel.suug.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 4:24 PM, Thomas Graf <tgraf@suug.ch> wrote:
> Without a) this whole feature is very limited. It requires a process to
> be registered to the cgroup before it creates any sockets.

I think that it's a bit more flexible than that - any newly created
sockets (or newly accepted sockets) will inherit the correct classid,
so it's only existing connections that don't get reclassified.

But the common case is that applications are going to be dropped in
the correct cgroup *before* they start, via mechanisms such as pam
login modules or job-control middleware.

> Otherwise
> these sockets will not have the proper classid value and traffic from
> and to this sockets will not be classified. I don't see how this is
> practical since many applications create their sockets when the
> application is started. F.e. a web browser is causing a bulk data
> transfer, admin/user notices this and wants to put it in a restricted
> cgroup, won't work.
>

Yes, for this particular case it doesn't work. But isn't it much more
likely that the admin/user will know that web-browsers tend to trigger
bulk data transfers and configure the system so that the web browser
always starts in its own cgroup, rather than trying to jump on it
after the fact?

Paul
