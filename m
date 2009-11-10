Return-Path: <linux-kernel-owner+w=401wt.eu-S1751554AbZKJKj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbZKJKj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 05:39:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbZKJKj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 05:39:56 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:36541 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbZKJKjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 05:39:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=m/zC6I3RFLL73ybLuUNRzqAwSPdpY+qW7qxD+Lsp9CiVskgJqt9v7Lfn3OOe7Xt6Sn
         MvSNe7kBgB7+tUEpm89prpmUd9ItaCiWcXJhXShLr5LFxD7SlHvuCrFQz1j//DhcLA23
         M6zGKd9z9NMjJgiD0htjEUqL/0yTAr5vsC8nI=
Date: Tue, 10 Nov 2009 11:40:04 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH v2] tracing: Protect the buffer from recursion in perf
Message-ID: <20091110104002.GE5255@nowhere>
References: <4AF24144.30003@redhat.com> <1257477185-7838-1-git-send-email-fweisbec@gmail.com> <1257848862.4648.33.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257848862.4648.33.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 11:27:42AM +0100, Peter Zijlstra wrote:
> There already is recursion protection in
> kernel/perf_event.c:perf_swevent_recursion_context() and thereabouts.
> Could you not fix this by widening its scope?


Hmm, indeed.
I could probably use perf_swevent_recursion_context() directly from
the tracing fill path. And then split up a bit do_perf_sw_event()
so that it continues to check the recursion for normal software events
but not for trace events (for which we would already explicitly
call perf_swevent_recursion_context()).

I'll try that, thanks!

