Return-Path: <linux-kernel-owner+w=401wt.eu-S1752912AbZLEHSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbZLEHSh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 02:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbZLEHSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 02:18:35 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:49137 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbZLEHSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 02:18:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=gDSEErZZXElRpwhExSyOAsIlSWDLSAlA7NGJKQ9anJ6pxMM8jMA9BjobJxxEs97gbB
         l0s4u02bTCQ9RLoNlaDmZ4o4QrPj5bpVo7rg5PieVJlIhCCHJSx/cfwkN8NZ2UOhBJii
         iWXCQNcuJNv6LNm7BcdZsItST74cuScIt128E=
MIME-Version: 1.0
In-Reply-To: <20091202204637.25408.41195.stgit@dhcp-100-2-132.bos.redhat.com>
References: <4B128ECF.9020906@redhat.com>
	 <20091202204637.25408.41195.stgit@dhcp-100-2-132.bos.redhat.com>
Date: Sat, 5 Dec 2009 16:18:38 +0900
X-Google-Sender-Auth: c62a516443972017
Message-ID: <2f11576a0912042318u4c9c90cetb4ce136e977c2596@mail.gmail.com>
Subject: Re: [PATCH v2] [RFC] tracepoint: Add signal coredump tracepoint
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       Jason Baron <jbaron@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/3 Masami Hiramatsu <mhiramat@redhat.com>:
> Add signal coredump tracepoint which shows signal number,
> mm->flags, limits, pointer to file structure and core
> file name.
>
> This tracepoint requirement comes mainly from the viewpoint of
> administrators. Since now we have introduced many coredump
> configurations (e.g. dumpable, coredump_filter, core_pattern,
> etc) and some of them can be modified by users, it will be hard
> to know what was actually dumped (or not dumped) after some
> problem happened on the system. For example, a process didn't
> generated core, coredump doesn't have some sections, etc.
> In those cases, the coredump tracepoint can help us to know
> why the core file is so big or small, or not generated, by
> recording all configurations for all processes on the system.
> That will reduce system-administration cost.

AFAIK, not-dumped case is important than dump successful case.
IOW, admin need to know why the crashed process was not dumped.

This tracepoint doesn't cover all failure case. especially
binfmt->core_dump() et.al.
IOW, this tracepoint seems too specialized piped-coredump feature.

What do you think this tracepoint's use case?
