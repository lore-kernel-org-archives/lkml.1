Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbXDDN7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbXDDN7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 09:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbXDDN7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 09:59:12 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:12311 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbXDDN7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 09:59:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=p61ROPZf0zgatuJ9c/ttwLxKyyd/NHwVJ+t+tBxgcsY+MvwP2fIUxUJejM4TdnlrYD+iBlv8XkT8aO2lelW09fpaM1QV0qE/SB+g5Ju1J0Ht9Imd0A6IlGJACWc4OvlfNsxmfLb7CzxXbkgGgP3KdDfdKQbWFF+vh85SXieIkEU=
Message-ID: <9a8748490704040659t43942e96t8e70d8785f851336@mail.gmail.com>
Date: Wed, 4 Apr 2007 15:59:10 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Maxim Uvarov" <muvarov@ru.mvista.com>
Subject: Re: Performance Stats: Kernel patch
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
In-Reply-To: <4613A4FF.9030202@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46124E93.2000408@ru.mvista.com>
	 <16797.1175641303@turing-police.cc.vt.edu>
	 <4613A4FF.9030202@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/07, Maxim Uvarov <muvarov@ru.mvista.com> wrote:
> Hello again,
>
[snip]
> New version of this patch. Please flay it.
>

A few small comments below.

>
> +config THREAD_PERF_STAT
> +       bool "Per-process (thread) performance statistics"
> +       depends on (X86 || PPC || MIPS)
> +       help
> +         Make available to the user the following new per-process
> (thread) performance statistics:

Get rid of the word "new" - it won't continue to be a "new" feature forever :-)

> +           * Involuntary Context Switches
> +           * Voluntary Context Switches
> +           * Number of system calls (option)

In the first two lines you Capitalize Each Word, but in the last line
you don't - why?
Shouldn't the first two have "Number of" prepended?
Perhaps it's just me, but I would write "(optional)" instead of "(option)".

In short, I'd suggest this :

           * Number of involuntary context switches
           * Number of voluntary context switches
           * Number of system calls (optional)

> +         This information is available via /proc/PID/status.

What about tools that currently parse /proc/PID/status ?  Don't you
risk breaking userland stuff by changing this file?   Wouldn't it be
better to use a new file?

> +
> +config THREAD_PERF_STAT_SYSC
> +       bool "enable syscall counter"

Capitalize the first word; "Enable syscall counter" .

> +       depends on THREAD_PERF_STAT
> +       help
> +          This option add syscalls counter to  /proc/PID/status.

I'd probably have written "This option adds a syscall counter to
/proc/PID/status."


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
