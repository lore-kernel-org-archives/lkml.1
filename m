Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbYJaTdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbYJaTdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 15:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbYJaTdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 15:33:07 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:43721 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbYJaTdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 15:33:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Cep3EaDLh/RXOCGpCxOpDavenXkZF4/Hn6r+mMHUS6BLfNg6xOQ/pBmw3EPs5zuQxD
         L1D+JEhMk8yCl53bTgms04LFcK47Ck/LHDM0s0U4zr3FsVAwPISc1aIbuawXchnQ5N8l
         oFXHO5DXecKdVHaWDc0lrQxws6ZKWnDIQpRJY=
Message-ID: <863e9df20810311233j13f996b8qa185cceddbd90849@mail.gmail.com>
Date: Fri, 31 Oct 2008 15:33:00 -0400
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH] ftrace: distinguish kretprobe'd functions in trace logs
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Al Viro" <viro@zeniv.linux.org.uk>, ananth@in.ibm.com,
       jkenisto@us.ibm.com, mhiramat@redhat.com
In-Reply-To: <alpine.DEB.1.10.0810311142220.22451@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <483C53EE.2060602@gmail.com>
	 <alpine.DEB.1.10.0810302227360.21031@gandalf.stny.rr.com>
	 <alpine.DEB.1.10.0810311036130.20157@gandalf.stny.rr.com>
	 <863e9df20810310832uadf4daay7b5a98b677d86561@mail.gmail.com>
	 <alpine.DEB.1.10.0810311142220.22451@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 11:50 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> Subject: ftrace: use kretprobe trampoline name to test in output
>
> When a function is kprobed, the return address is set to the
> kprobe_trampoline, or something similar. This caused the output
> of the trace to look confusing when the parent seemed to be this
> "kprobe_trampoline" function.
>
> To fix this, Abhishek Sagar added a test of the instruction pointer
> of the parent to see if it matched the kprobe_trampoline. If it
> did, the output would print a "[unknown/kretprobe'd]" instead.
>
> Unfortunately, not all archs do this the same way, and the trampoline
> function may not be exported, which causes failures in builds.
>
> This patch will compare the name instead of the pointer to see
> if it matches. This prevents us from depending on a function from
> being exported, and should work on all archs. The worst that can
> happen is that an arch might use a different name and then we
> go back to the confusing output. At least the arch will still build.
>
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  kernel/trace/trace.c |   39 +++++++++++++++++++++------------------
>  1 file changed, 21 insertions(+), 18 deletions(-)

Looks good, and worked on x86-32.

Acked-by: Abhishek Sagar <sagar.abhishek@gmail.com>
