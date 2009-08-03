Return-Path: <linux-kernel-owner+w=401wt.eu-S1754996AbZHCNst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbZHCNst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 09:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754905AbZHCNss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 09:48:48 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:54334 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754878AbZHCNsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 09:48:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYEAMuCdkpMQWXi/2dsb2JhbACBUs8NhBgFgUqCTw
Date: Mon, 3 Aug 2009 09:48:44 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Matthieu CASTET <matthieu.castet@parrot.com>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, rostedt@goodmis.org
Subject: Tracing thread name (was: ltt comm tracking)
Message-ID: <20090803134843.GB23455@Krystal>
References: <4A76E42D.7010908@parrot.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4A76E42D.7010908@parrot.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:37:41 up 156 days, 10:03,  5 users,  load average: 1.25, 0.92,
	0.80
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthieu CASTET (matthieu.castet@parrot.com) wrote:
> Hi,
> 
> I use ltt on a 2.6.27 on an arm architecture.
> It works quite well, but I have a minor problem :
> 
> my application sets thread name with prctl PR_SET_NAME. But ltt viewer
> doesn't seem to saw it.
>

Hrm, I guess we might want to instrument set_task_comm as you propose to
get the correct process name, but if this gets us the thread name, I
think it's only an implementation side-effect:

If I look at the man page:

PRCTL(2)

       PR_SET_NAME (since Linux 2.6.9)
              Set the process name for the calling process, using the value in
              the location pointed to by (char *) arg2.  The name can be up to
              16  bytes  long,  and  should  be null terminated if it contains
              fewer bytes.

It seems to officially set the process name, not thread name.

The way LTTng handles thread names is by adding a userspace "thread
branding" event. It should be executed at thread startup. The downside
of the current LTTng approach is that we cannot know the name of threads
already executing before we started tracing.

Ideally, having something like prctl PR_SET/GET_THREAD_NAME would
probably make sense.

Mathieu

> I don't know how/where ltt extracts the comm name, but may be a
> tracepoint should be added in set_task_comm ?
> 
> Any idea how to make ltt use name set with prctl ?
> This will make more easier to read trace for application with lot's of
> threads.
> 
> 
> Thanks
> 
> Matthieu CASTET
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
