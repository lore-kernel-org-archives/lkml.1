Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbZLSVjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbZLSVjt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 16:39:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbZLSVjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 16:39:49 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52797 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbZLSVjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 16:39:48 -0500
Subject: Re: [PATCH 1/1 v2] perf record: We should fork only if a program
 was specified to run
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
In-Reply-To: <1261257771-10263-1-git-send-email-acme@infradead.org>
References: <1261257771-10263-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 19 Dec 2009 22:39:01 +0100
Message-ID: <1261258741.4314.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-12-19 at 19:22 -0200, Arnaldo Carvalho de Melo wrote:
> @@ -550,7 +551,7 @@ static int __cmd_record(int argc __used, const char **argv)
>                         return err;
>         }
>  
> -       if (!system_wide)
> +       if (!system_wide && profile_cpu == -1)
>                 event__synthesize_thread(pid, process_synthesized_event,
>                                          session); 

Not actually sure about this bit though, since we now have
per-task-per-cpu things, the profile_cpu is also used to !system_wide.



