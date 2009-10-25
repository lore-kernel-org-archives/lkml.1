Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbZJYXbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbZJYXbq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 19:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbZJYXbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 19:31:45 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55485 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919AbZJYXbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 19:31:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QzLj4S4QI20swGSfacaExfz1CW8XjyG1V+V/RqG0vcXrvLhm+WZflxQW/tOmP79mZM
         PhO3yyv4caOWM9SfrTu9pfPj3J1vRrqcGtVCKsOCV9dNt0iwWb309KAltBLgUPjLUIn8
         5GjQEdUTm31AuGeqXUjzrjunbWYLWPhnUs/IQ=
MIME-Version: 1.0
In-Reply-To: <4AE32926.2020005@web.de>
References: <1256393818-8921-1-git-send-email-fweisbec@gmail.com>
	 <1256393818-8921-5-git-send-email-fweisbec@gmail.com>
	 <4AE32926.2020005@web.de>
Date: Mon, 26 Oct 2009 00:31:46 +0100
Message-ID: <c62985530910251631v4c0ccf7ak91b376c97666001b@mail.gmail.com>
Subject: Re: [PATCH 4/6] hw-breakpoints: Rewrite the hw-breakpoints layer on 
	top of perf events
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/24 Jan Kiszka <jan.kiszka@web.de>:
> Since commit 3d53c27d05, KVM uses current->thread.debugregs for
> restoring the host state in case the guest played with breakpoints. We
> need an equivalent interface to restore ptrace breakpoints and all
> others currently in use.
>
> Jan


Well, dr6 is still stored in the current thread.
dr7 has a per cpu variable containing its value.

So what remains is to have a per cpu variable for dr0-3
which is updated when perf schedules in/out a profiled context.
I can do that in a v3.

Thanks.
