Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbXKAQMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbXKAQMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 12:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbXKAQMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 12:12:42 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34457 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbXKAQMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 12:12:42 -0400
Subject: Re: [patch] PID namespace design bug, workaround
From: Dave Hansen <haveblue@us.ibm.com>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Pavel Emelyanov <xemul@openvz.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <4729E936.4040400@redhat.com>
References: <20071101144307.GA29566@elte.hu> <4729E7E4.8070208@openvz.org>
	 <4729E936.4040400@redhat.com>
Content-Type: text/plain
Date: Thu, 01 Nov 2007 09:12:28 -0700
Message-Id: <1193933548.6271.78.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-01 at 07:56 -0700, Ulrich Drepper wrote:
> Pavel Emelyanov wrote:
> > With this set we'll be able to mark pid namespaces as EXPERIMENTAL
> > or even BROKEN, so nobody will be able to crate them. So can we, please, 
> > keep things as they are for now - the appropriate fix will be ready 
> > soon.
> 
> You sound far too optimistic for my taste.  I probably haven't seen the
> proposal you have in mind but everything else I have seen simply doesn't
> work without breaking something.

Yeah, we definitely realize that this inhibits things that were
perfectly fine before.  

As Eric mentioned in his reply to your message last year, the primary
goal here is isolation.  We'd eventually like to be able to pick a
container up and move it to another system.  That's going to be awfully
hard if the container is sharing a resource with a part of the system
which is not moving.

Pid namespaces (along with the others) give us the isolation to keep
these interactions from happening except in a controlled manner,
breaking the ties that might bind it to one particular system.

Think of how many user-visible apis deal with files and filenames.
However, there can certainly be files that are unavailable to certain
processes based on their membership in a particular filesystem
namespaces.  In fact, we use chroot() to try and _make_ certain files
unavailable.

-- Dave

