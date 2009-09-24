Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbZIXUaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbZIXUaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 16:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbZIXUaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 16:30:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:43418 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbZIXUaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 16:30:10 -0400
Subject: Re: [GIT PULL v2] bkl tracepoints + filter regex support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
In-Reply-To: <20090924201622.GA15459@elte.hu>
References: <1253821775-8618-1-git-send-email-fweisbec@gmail.com>
	 <20090924201509.GA26573@elte.hu>  <20090924201622.GA15459@elte.hu>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 22:30:00 +0200
Message-Id: <1253824200.18939.173.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-24 at 22:16 +0200, Ingo Molnar wrote:

> There's one thing Peter noticed: this is not C syntax anymore. It would 
> be really nice to keep filter expressions a subset of C.

Also:

> This patch provides basic support for regular expressions in filters.
> 
> It supports the following types of regexp:
> 
> - *match_beginning
> - *match_middle*
> - match_end*
> - !don't match
> 
> Example:
>         cd /debug/tracing/events/bkl/lock_kernel
>         echo 'file == "*reiserfs*"' > filter
>         echo 1 > enable

It says regex, but its not.

Regex would look like: "^.*reiserfs.*$", or simply "reiserfs"

What you implemented is called glob-matching.

If you want to keep this C syntax, you could consider something like:

 glob_match(file, "*reiserfs*")

or something.

