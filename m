Return-Path: <linux-kernel-owner+w=401wt.eu-S1753365AbYI3NZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbYI3NZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 09:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbYI3NZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 09:25:45 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:37609 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbYI3NZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 09:25:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dzNjmMvmwT/YvCH4aKkVrXX1a/4KzHCwyGDEFhmuSnXEK5HCLqCpTFW1nQ+BzrhXzi
         lK/PQXm06uFiNcioGkzIDsuEz9vEfZbhyQ1M5w9YQAzDt0qq0vQvAVPaT7P8ZHTO8U72
         P318mhvkmzzObIOz4/HZFRqn+eKjlXh63le9o=
Message-ID: <c62985530809300625p6c178c0ew6b9619998c3d5011@mail.gmail.com>
Date: Tue, 30 Sep 2008 15:25:42 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH V2 -tip 3/4] Tracing/ftrace: Adapt mmiotrace to the new type of print_line
Cc: "Ingo Molnar" <mingo@elte.hu>, "Pekka Paalanen" <pq@iki.fi>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0809300844270.1984@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48E11E1E.7010001@gmail.com>
	 <20080929221934.260306dd@daedalus.pq.iki.fi>
	 <20080930085241.GB10374@elte.hu>
	 <c62985530809300539o2842c14fk16708abaf69c4e2f@mail.gmail.com>
	 <alpine.DEB.1.10.0809300844270.1984@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/30 Steven Rostedt <rostedt@goodmis.org>:
>
> OK, I'll nuke the ring_buffer_lock :-/
>
> The trace_pipe calls that and then calls print_trace_line which will
> eventually lock the buffer again. This is a bug on my part. I'll fix that
> today.
>
> Thanks,

Strange, I can't see any case where print_trace_line could call the
ring_buffer_lock.
Hmm, I will see in your patch.

Ingo, I just saw one damage from the merging, trace_empty() returns
TRACE_TYPE_HANDLED. The type is wrong, it should return 1.
It's not urgent since the value is the same. Should I send a patch for
such a small error?

Thanks.
