Return-Path: <linux-kernel-owner+w=401wt.eu-S1752927AbZAZPmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbZAZPmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 10:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZAZPmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 10:42:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45185 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbZAZPmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 10:42:00 -0500
Date: Mon, 26 Jan 2009 10:41:59 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH -tip] x86: ftrace - simplify wait_for_nmi
In-Reply-To: <20090126152802.GA12465@localhost>
Message-ID: <alpine.DEB.1.10.0901261041430.9334@gandalf.stny.rr.com>
References: <20090126152802.GA12465@localhost>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 26 Jan 2009, Cyrill Gorcunov wrote:

> Get rid of 'waited' stack variable.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

Thanks Cyrill,

Either I or Ingo will pull it in.

-- Steve

> ---
>  arch/x86/kernel/ftrace.c |   11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6.git/arch/x86/kernel/ftrace.c
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/ftrace.c
> +++ linux-2.6.git/arch/x86/kernel/ftrace.c
> @@ -133,15 +133,14 @@ void ftrace_nmi_exit(void)
>  
>  static void wait_for_nmi(void)
>  {
> -	int waited = 0;
> +	if (!atomic_read(&in_nmi))
> +		return;
>  
> -	while (atomic_read(&in_nmi)) {
> -		waited = 1;
> +	do {
>  		cpu_relax();
> -	}
> +	} while(atomic_read(&in_nmi));
>  
> -	if (waited)
> -		nmi_wait_count++;
> +	nmi_wait_count++;
>  }
>  
>  static int
> 
> 
