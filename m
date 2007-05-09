Return-Path: <linux-kernel-owner+w=401wt.eu-S970832AbXEIAA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970832AbXEIAA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 20:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970511AbXEIAAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 20:00:08 -0400
Received: from gw.goop.org ([64.81.55.164]:54518 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S970379AbXEIAAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 20:00:06 -0400
Message-ID: <46410F02.906@goop.org>
Date: Tue, 08 May 2007 17:00:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       David Howells <dhowells@redhat.com>,
       Bj?rn Steinbrink <B.Steinbrink@gmx.de>
Subject: Re: [patch 3/4] split usermodehelper setup from execution
References: <20070508205129.064843364@goop.org>	 <20070508205517.256147592@goop.org> <1178668171.7286.55.camel@localhost.localdomain>
In-Reply-To: <1178668171.7286.55.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> call_usermodehelper_pipe()?  Erk.  Grepping... for core dumping via a
> process?  Without modifying the ELF core dumper (at least) to handle
> short writes?  Why not dump it in an agreed location and exec the
> process with that as an arg?
>   

I think the idea is that you might want to send it over the net on a
diskless system, or filter/compress the core before it hits disk because
you don't have enough space.

> When did this go in?  2.6.19... hmm, too late to rip it out I guess 8(
>
> Anyway, I'm not sure exposing an open-ended interface wins: refactoring
> internally definitely makes sense though.

Well, I added this specifically so I could add a cleanup callback, which
can be used to free a dynamically allocated argv array (see the
following patch).  And if you're going to have all this stuff, you may
as well make it work properly together.  Why have "you can set the
session keyring *or* use a pipe for stdin"?

As distended as it is, at least it actually fits together somewhat
coherently now.  I'd be up for dropping the single-use wrapper functions.

    J
