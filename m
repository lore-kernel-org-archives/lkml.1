Return-Path: <linux-kernel-owner+w=401wt.eu-S1161090AbXBTX2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161090AbXBTX2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 18:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161082AbXBTX2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 18:28:20 -0500
Received: from smtp-out.google.com ([216.239.45.13]:56375 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161090AbXBTX2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 18:28:19 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Z0DvuC0LjEraIHHjQSUSa25kV/xgtLrP7IXuHcl80jYL5imyigTTQiyE7k3eCu/zY
	4DKhwtH+VZLtMckgQrx2A==
Message-ID: <6599ad830702201528x72e942caq67f8be9bd16c618c@mail.gmail.com>
Date: Tue, 20 Feb 2007 15:28:07 -0800
From: "Paul Menage" <menage@google.com>
To: "Sam Vilain" <sam@vilain.net>
Subject: Re: [PATCH 0/7] containers (V7): Generic Process Containers
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, akpm@osdl.org, pj@sgi.com,
       sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       vatsa@in.ibm.com, containers@lists.osdl.org, winget@google.com,
       rohitseth@google.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <45DB7D05.2030800@vilain.net>
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
	 <6599ad830702201419n2fe02661y58f09f7dc8d23d88@mail.gmail.com>
	 <45DB7D05.2030800@vilain.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/20/07, Sam Vilain <sam@vilain.net> wrote:
>
> I don't necessarily agree with the 'heirarchy' bit.  It doesn't have to
> be so segregated.  But I think we already covered that in this thread.

OK, but it's much easier to use a hierarchical system as a flat system
(just don't create children) than a flat system as a hierarchical
system. And others do seem to want a hierarchy for their process
groupings.

>
> I agree with the comment on the abuse of the term "namespace", though
> consider that it has already been abused with the term IPC namespaces.

That doesn't seem like an abuse to me at all - you're controlling what
IPC object a given name (shm_id, sem_id or msg_id) refers to for any
given group of processes.

> We have for some time been using it to refer to groupable entities
> within the kernel that are associated with tasks, even if they don't
> involve named entities that clash within a particular domain.  But there
> is always an entity and a domain, and that is the key point I'm trying
> to make - the features you are putting forward are no different to the
> examples that we made specifically for the purpose of setting the
> standard for further features to follow.

They're very similar, I agree. An important difference is that things
like pid/mount namespaces are simply ways of controlling the
visibility of existing unix concepts, such as processes or
filesystems. You don't need additional configuration to make them
useful, as unix already has standard ways of manipulating them.

Things like resource controllers typically require additional
configuration to control how much resources each group of processes
can consume, etc. Also, it appears to be much more common to want to
move tasks between different resource controllers than to move them
between different namespaces. (And in order to configure and move, you
need to be able to name)

The configuration, naming and movement are the features that my
container patch provides on top of the features that nsproxy provides
for namespaces.

> anyway, feel free to flog this old dead horse and suggest different
> terms.  We've all had long enough to think about it since so maybe it's
> worth it, but with any new term it should be really darned clear that
> they're essentially the same thing as namespaces, or otherwise be really
> likable.

What you're calling a "namespace", I'm calling a "subsystem state".
Essentially they're the same thing. The important thing that generic
containers provide is a standard way to manipulate "subsystem states"
or "namespaces".

Paul
