Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbYJXIGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbYJXIGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 04:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751057AbYJXIGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 04:06:18 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:44105 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbYJXIGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 04:06:16 -0400
Date: Fri, 24 Oct 2008 11:05:25 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] ftrace: handle generic arch calls
Message-ID: <20081024080525.GA21322@cs181140183.pp.htv.fi>
References: <alpine.DEB.1.10.0810210931190.23042@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0810210931190.23042@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 09:35:26AM -0400, Steven Rostedt wrote:
> 
> The recordmcount script requires that the actual arch is passed in.
> This works well when ARCH=i386 or ARCH=x86_64 but does not handle the
> case of ARCH=x86.
> 
> This patch adds a parameter to the function to pass in the number of
> bits of the architecture. So that it can determine if x86 should be
> run for x86_64 or i386 archs.
>...
> --- linux-compile.git.orig/scripts/recordmcount.pl	2008-10-21 09:25:45.000000000 -0400
> +++ linux-compile.git/scripts/recordmcount.pl	2008-10-21 09:28:36.000000000 -0400
>...
> @@ -129,6 +130,14 @@ my $function_regex;	# Find the name of a
>  			#    (return offset and func name)
>  my $mcount_regex;	# Find the call site to mcount (return offset)
>  
> +if ($arch eq "x86") {
> +    if ($bits == 64) {
> +	$arch = "x86_64";
> +    } else {
> +	$arch = "xi386";
>...

After fixing the obvious typo here the 32bit build worked for me.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

