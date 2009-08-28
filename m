Return-Path: <linux-kernel-owner+w=401wt.eu-S1751221AbZH1BZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221AbZH1BZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 21:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbZH1BZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 21:25:33 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:39950 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbZH1BZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 21:25:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ebcgsiEEyrp9ctWnHHcmvuATAVDpQ3kjiAiOXw7UVFa3p+TPyz4d7wQXwqTcDYxnPo
         Y+ybv6QT8ICAaaWEGSyWCGiesRUlsOi3avj3beBIDnaGUDKNBJNkMs3NAzKEr6D7M99u
         1eQkZbZHp+ou5dPqkcqy20WqHa6YhOpmo8QBc=
Date: Fri, 28 Aug 2009 03:25:31 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] perf tools: Only save the event formats we need
Message-ID: <20090828012530.GA6018@nowhere>
References: <1251421798-9101-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251421798-9101-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 28, 2009 at 03:09:58AM +0200, Frederic Weisbecker wrote:
> While opening a trace event counter, every events are saved in the
> trace.info file. But we only want to save the specifications of the
> events we are using.



I must confess I haven't done that because I care much about the amount
of saved format, you can also beat me because this patch regress perf trace
in that it won't support the trace appending mode anymore (for now).

That said, tracing/events/*/*/format is full of non trivial cases.
perf trace was failing because it can't yet handle scalar dereference
in the format arguments (since the recent sys_enter tracepoint add).

So what I plan toward this patch is to start iterating on trivial
cases and make them work well without beeing annoyed by format fetching
that are not supported yet.

