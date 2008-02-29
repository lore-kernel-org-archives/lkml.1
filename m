Return-Path: <linux-kernel-owner+w=401wt.eu-S1759958AbYB2R7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759958AbYB2R7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 12:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756274AbYB2R7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 12:59:12 -0500
Received: from smtp-out.google.com ([216.239.45.13]:25287 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171AbYB2R7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 12:59:11 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=EQL8AZzbyJbxQ1xC2zA5FtFx7Y23VW5D83YKK19/U62fAFSNyPBqxJXXgOSSken7L
	QTMcW3YkkMNO9Z4XpvCCQ==
Message-ID: <6599ad830802290959h5a736820i591ced2813f3014f@mail.gmail.com>
Date: Fri, 29 Feb 2008 09:59:00 -0800
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [RFC] [PATCH] Re: Prefixing cgroup generic control filenames with "cgroup."
Cc: akpm@linux-foundation.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
       a.p.zijlstra@chello.nl, xemul@openvz.org
In-Reply-To: <20080229093013.1e136398.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6599ad830802281314s25c033d6tc021725ae28aef8d@mail.gmail.com>
	 <20080228132142.4d4b1eef.akpm@linux-foundation.org>
	 <6599ad830802281328q162d0585v3ac6b45a119a4a05@mail.gmail.com>
	 <20080228134027.05b2aa87.akpm@linux-foundation.org>
	 <6599ad830802281406t38e486d8g267df1873bc754c2@mail.gmail.com>
	 <20080228142100.2dce0e46.akpm@linux-foundation.org>
	 <47C79F39.5080005@google.com> <20080229002051.86de45a5.pj@sgi.com>
	 <6599ad830802290134u4cdfba44v39fd725b5c422720@mail.gmail.com>
	 <20080229093013.1e136398.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 7:30 AM, Paul Jackson <pj@sgi.com> wrote:
>
>  The pattern might be stronger (more restrictive) than "[a-z].*"
>
>  The pattern might be something like:
>   1) the known set of existing names (a short, specific list), plus
>   2) "[a-z]+\.[a-z]+(_[a-z]+)*"

Why make it more complex? If we're going for a solution that involves
an implicit partition of the namespace that the user has to be aware
of, then simple is good.

>  Note here "safe for user created" names just means safe from collision
>  with kernel generated names, not necessarily safe from collision with
>  other user generated names.
>
>  That is regardless of what you do here, you cannot protect the
>  delicate user from possible collision.  You can only protect them
>  from collision with "your" names.

Of course - I don't think anyone's suggesting that the kernel can do
anything about two competing users fighting over who gets to create
cgroup "Foo". But IMO it's crazy to have multiple uncoordinated
userspace cgroup managers.

>  > >  And did I say incompatible with released versions?
>  >
>  > Not at all incompatible if it requires a mount option to enable it ...
>
>  Ah - are you saying I missed another detail?

That was one of the questions that I left open - we could add it
defaulting to off, unless a mount option was given.

>
>   /mnt/cgroup/groups/user_created_groupname1/groups/user_created_groupname2
>  or
>
>   /mnt/cgroup/user_created_groupname1/user_created_groupname2

Correct.

>
>  So code that knows something about these paths has to work with either
>  form (since not all code using these paths will control the mount
>  relevant option.)

Yes, but compared to all the other configuration details that a
userspace cgroup manager needs to work with, I think this would be a
minor one.

>
>  I hope I misunderstood something here.
>
>
>  > That leaves a bit of an ugly taste in my mouth  ...
>
>  Could you spell out the key reason -you- find it distasteful,  perhaps
>  for a stronger pattern such as "[a-z]+\.[a-z]+" I consider above?
>  Perhaps I'm missing some reason to share in your revulsion.

The main reason it's not my primary choice is that it's an implicit
rule that the user has to know about or risk getting bitten in future.
Making that rule complex is even worse, I think.

Of course it does have the big advantage that no code changes are
needed, just documentation. So if people prefer it, then I'm not going
to fight hard.

Paul
