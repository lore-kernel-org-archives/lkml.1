Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbYK0O2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbYK0O2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 09:28:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbYK0O16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 09:27:58 -0500
Received: from ik-out-1112.google.com ([66.249.90.177]:57432 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbYK0O15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 09:27:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hkWOG3waK3RwRJ8vjMPcqbRB8qEkHpMLsQAHKXkIuBd3p88Z0MAAwgv4mbprj3k0VD
         0gZOgtcVADE/oSJFx2z4BehlGwNJZ5pizB5Mk95OfWzNT2E01tx+G92DW2ImBUGMf73d
         gybyU3hQLgiIqI9NZ9/zlQN/P4sezMPYtuNa8=
Message-ID: <492EAE65.1040903@gmail.com>
Date: Thu, 27 Nov 2008 16:27:49 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Frank Ch. Eigler" <fche@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, srostedt@redhat.com,
       sandmann@daimi.au.dk, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 2/2] tracing: identify which executable object the userspace
 address belongs to
References: <1227353328-16104-1-git-send-email-edwintorok@gmail.com> <1227353328-16104-3-git-send-email-edwintorok@gmail.com> <y0my6z798de.fsf@ton.toronto.redhat.com> <1227782505.4454.1393.camel@twins> <20081127124851.GC23480@redhat.com> <492E9AB2.9030202@gmail.com> <20081127141054.GB25657@elte.hu>
In-Reply-To: <20081127141054.GB25657@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-11-27 16:10, Ingo Molnar wrote:
> Your patches are nice. Right now they are in tracing/core and 
> linux-next already.

Thanks. I can move on to the lock latency tracing ;)

I'll send out a draft of tracepoints that I would need to trace lock
latency.
I'll try to put them in same place as lockstat (but not necesarely
depending on lockstat being enabled).

Once we reach a lock-tracepoints patch that all agree upon, I can (try
to) write a ftrace-lock-latency that will have a histogram view
(as you've suggested similar to what the likely/unlikely tracer already
does), but also show separate counts per unique kernel/user stacktrace.

Or  I could add the tracepoints inside lockstat (now that it has contend
with points feature), and use the information already gathered by lockstat,
but augment it with finer grained counts per kernel/user stacktrace.
(again there would be an ftrace plugin that would register with the
tracepoints, and show
the per stacktrace statistic in /sys/kernel/debug/tracing/trace).

Which approach should I try first?

Although my goal would be to be able to use this feature by simply
turning on a flag at runtime (whether something in /proc or
/sys/kernel/debug),
rather than rebooting to a different kernel, it may be easier to
implement this at first by using what lockstat already provides, and
later improving it
to work w/o lockstat.

What do you think?

Best regards,
--Edwin

