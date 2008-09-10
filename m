Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbYIJXxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbYIJXxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 19:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbYIJXxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 19:53:35 -0400
Received: from smtp-out.google.com ([216.239.33.17]:9649 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbYIJXxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 19:53:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=lRJNs4ujgyhnXOhny+pYA4cxTH7Hvdm/rKHlmrzcWaJSZGSIRgbkExkkPqJYFPrZ7
	JAruqj/bsGOwkKkocNH8g==
Message-ID: <6599ad830809101651u79a0efb7y8fa7288de6e48c8a@mail.gmail.com>
Date: Wed, 10 Sep 2008 16:51:55 -0700
From: "Paul Menage" <menage@google.com>
To: "Thomas Graf" <tgraf@suug.ch>
Subject: Re: [PATCH 1/2] Traffic control cgroups subsystem
Cc: "Ranjit Manomohan" <ranjitm@google.com>, davem@davemloft.net,
       akpm@linux-foundation.org, kaber@trash.net, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20080910234523.GK20815@postel.suug.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0809101040280.7050@ranjit.corp.google.com>
	 <20080910220115.GH20815@postel.suug.ch>
	 <166fe7950809101556q61cb7e30m2d5e758304618f61@mail.gmail.com>
	 <6599ad830809101604o71b2fb82k2aca1eb0fd8ab6d8@mail.gmail.com>
	 <20080910232413.GJ20815@postel.suug.ch>
	 <6599ad830809101631q51371f75w2ab9f73ef2414f90@mail.gmail.com>
	 <20080910234523.GK20815@postel.suug.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 4:45 PM, Thomas Graf <tgraf@suug.ch> wrote:
>
> That's argueable I guess. Likely or not, it doesn't make sense to
> add such restrictions if not required, especially not when it is
> trivial to just look at the cgroup of the task directly.

Isn't a very large fraction of outgoing network traffic driven from
net_tx_action(), which doesn't execute in the context of the sending
process? Or am I missing something?

You claimed "In the most common case, the packet is not queued before
it hits the qdisc so this takes away a lot of complexity and is very
fast but should still be sufficient.". But is that really true on a
system where the network is busy? (Which is after all exactly the case
where you care about accurate traffic accounting/policing)

Paul
