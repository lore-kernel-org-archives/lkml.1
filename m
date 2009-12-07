Return-Path: <linux-kernel-owner+w=401wt.eu-S1757595AbZLGOnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595AbZLGOnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 09:43:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756604AbZLGOnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 09:43:10 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:54283 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588AbZLGOnJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 09:43:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dSV4zzBuumZKB26ZonFu8hZ9BaGufjp4cY4WpgjuoOmJw+lfjLHFCY5wLm5bTNQKWJ
         Foa6usVZviYxZKNbx5U2A1xsydwnA4caWm2IHR67V7QD0mUdLaKyeM/nPauVz3uHtaYb
         cJHbwHmvXeBiGRs+PbkTm+ff5VumAd0pSntIE=
MIME-Version: 1.0
In-Reply-To: <4B1CB1B7.7080106@cn.fujitsu.com>
References: <4B1CB14A.4080402@cn.fujitsu.com> <4B1CB1B7.7080106@cn.fujitsu.com>
Date: Mon, 7 Dec 2009 15:43:15 +0100
Message-ID: <c62985530912070643l69edb5e4x2b74ad8ff67b5b2d@mail.gmail.com>
Subject: Re: [PATCH 06/13] function-graph: Allow writing the same val to 
	set_graph_function
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/7 Li Zefan <lizf@cn.fujitsu.com>:
>  # echo 'do_open' > set_graph_function
>  # echo 'do_open' >> set_graph_function
>  bash: echo: write error: Invalid argument
>
> Make it valid to write the same value to set_graph_function,
> which is consistent with set_ftrace_filter interface.
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>


> ---
>  kernel/trace/ftrace.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index ff8aecd..7968762 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -2552,10 +2552,9 @@ ftrace_set_func(unsigned long *array, int *idx, char *buffer)
>                                        exists = true;
>                                        break;
>                                }
> -                       if (!exists) {
> +                       if (!exists)
>                                array[(*idx)++] = rec->ip;
> -                               found = 1;
> -                       }
> +                       found = 1;
>                }
>        } while_for_each_ftrace_rec();
>
> --
> 1.6.3
>
>
