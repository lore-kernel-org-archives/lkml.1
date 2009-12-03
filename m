Return-Path: <linux-kernel-owner+w=401wt.eu-S1756291AbZLCPZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291AbZLCPZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 10:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756128AbZLCPZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 10:25:41 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:5247 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbZLCPZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 10:25:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=jsNI1MfAzqJHNwUzZvqz3fOWmz4gcpwZgnFZLJtZuLo7GcVz7lyHQ0F6SCiNup+H/O
         TyKFqhq55/x6/L14c6K+m6IKwEGelCquCkNt/v8f5TsdwTRJqQELhDaFnC7YkViEnTIo
         rBs6PY9/jq3LRTLlLIf3e+2F8ffjvFO7vprs4=
MIME-Version: 1.0
In-Reply-To: <4B177878.2090002@redhat.com>
References: <20091201075744.4456.48125.sendpatchset@localhost.localdomain>
	 <20091201154412.4002a0d8@linux.intel.com>
	 <4B177878.2090002@redhat.com>
Date: Thu, 3 Dec 2009 08:18:11 -0700
X-Google-Sender-Auth: 9d52d35b69c950a4
Message-ID: <fd3b2d10912030718q30176616r1ac3b71a4399fc0b@mail.gmail.com>
Subject: Re: [Patch] tty: move a definition out of switch block
From: Joe Peterson <joe@skyrush.com>
To: Cong Wang <amwang@redhat.com>
Cc: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 3, 2009 at 01:36, Cong Wang <amwang@redhat.com> wrote:
> Generally putting variables local in the local scope is fine, but
> not for 'switch' block, to be more precisely, not for the case
> where putting local variables between 'switch' and its _first_
> label, IMO.

It is fine to declare variables at the start of a switch statement.
What *is* incorrect is either initializing such declared variables
(they won't get initialized) or declaring variables *after* a case
label (throws a compile error).

> It can lead to misunderstanding easily, since 'switch'
> jumps to its first label at a first glance. I know in this case
> the code is _not_ wrong, but again, it's not good for reading.

I would think the declaration inside the start of the switch block
would just indicate to the reader that the variable is local to the
switch block scope.

> Also, there's no conflicts if we put it out of 'switch' block.

But then the scope of these variables becomes larger than it need be.

-Joe
