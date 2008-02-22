Return-Path: <linux-kernel-owner+w=401wt.eu-S1762268AbYBVSsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762268AbYBVSsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 13:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756133AbYBVSso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 13:48:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59261 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099AbYBVSsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 13:48:43 -0500
Date: Fri, 22 Feb 2008 10:48:28 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: don't save unreliable stack trace entries
Message-ID: <20080222104828.3006cd1d@laptopd505.fenrus.org>
In-Reply-To: <47BF17F5.4040605@gmail.com>
References: <47BF17F5.4040605@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Feb 2008 19:44:05 +0100
Vegard Nossum <vegard.nossum@gmail.com> wrote:

> I find the following patch to make saved stack traces so much easier
> to decipher. There might be other uses of save_stack_trace() that I
> am not aware of, though. Also, I suggest changing the underlying
> struct stack_trace to include the reliable/unreliable information.
> This, however, requires all users of save_stack_trace() and all
> arches saving this information to change.
> 
> Kind regards,
> Vegard Nossum
> 
> 
>  From 5edfd896c5f0d728111df3d8cae729a375f29d3c Mon Sep 17 00:00:00
> 2001 From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Fri, 22 Feb 2008 19:23:58 +0100
> Subject: [PATCH] x86: don't save unreliable stack trace entries
> 
> Currently, there is no way for print_stack_trace() to determine
> whether a given stack trace entry was deemed reliable or not, simply
> because save_stack_trace() does not record this information. (Perhaps
> needless to say, this makes the saved stack traces A LOT harder to
> read, and probably with no other benefits, since debugging features
> that use save_stack_trace() most likely also require frame pointers,
> etc.)
> 
> This patch reverts to the old behaviour of only recording the
> reliable trace entries for saved stack traces.
> 
> Signed-off-by: Vegard Nossum <vegardno@ifi.uio.no>
> ---
>   arch/x86/kernel/stacktrace.c |    4 ++++
>   1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/stacktrace.c
> b/arch/x86/kernel/stacktrace.c index 02f0f61..c28c342 100644
> --- a/arch/x86/kernel/stacktrace.c
> +++ b/arch/x86/kernel/stacktrace.c
> @@ -25,6 +25,8 @@ static int save_stack_stack(void *data, char *name)
>   static void save_stack_address(void *data, unsigned long addr, int
> reliable) {
>   	struct stack_trace *trace = data;
> +	if (!reliable)
> +		return;
>   	if (trace->skip > 0) {
>   		trace->skip--;
>   		return;
> @@ -37,6 +39,8 @@ static void
>   save_stack_address_nosched(void *data, unsigned long addr, int
> reliable) {
>   	struct stack_trace *trace = (struct stack_trace *)data;
> +	if (!reliable)
> +		return;
>   	if (in_sched_functions(addr))
>   		return;
>   	if (trace->skip > 0) {


I was about to make a patch for this second chunk myself and submit it, so
for the second chunk a strong:
Acked-by: Arjan van de Ven <arjan@linux.intel.com>

Thanks for beating me to it ;-)

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
