Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab0BCJ2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 04:28:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35845 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756250Ab0BCJ2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 04:28:49 -0500
Message-ID: <4B69409E.9010301@zytor.com>
Date: Wed, 03 Feb 2010 01:23:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org,
       xiaoguangrong@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf tools: Use O_LARGEFILE to open perf data
 file
References: <4B68F32A.9040203@cn.fujitsu.com> <tip-b8f46c5a34fa64fd456295388d18f50ae69d9f37@git.kernel.org>
In-Reply-To: <tip-b8f46c5a34fa64fd456295388d18f50ae69d9f37@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2010 12:45 AM, tip-bot for Xiao Guangrong wrote:
> 
> perf tools: Use O_LARGEFILE to open perf data file
> 
> Open perf data file with O_LARGEFILE flag since its size is
> easily larger that 2G.
> 
> +#define _LARGEFILE64_SOURCE
> +#define _FILE_OFFSET_BITS 64
> +
>  #include "builtin.h"
>  
>  #include "perf.h"
> @@ -451,7 +454,7 @@ static int __cmd_record(int argc, const char **argv)
>  		append_file = 0;
>  	}
>  
> -	flags = O_CREAT|O_RDWR;
> +	flags = O_CREAT|O_RDWR|O_LARGEFILE;
>  	if (append_file)
>  		file_new = 0;
>  	else
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index 2bb2bdb..ed3efd7 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -1,3 +1,6 @@
> +#define _LARGEFILE64_SOURCE
> +#define _FILE_OFFSET_BITS 64
> +
>  #include <sys/types.h>
>  #include <byteswap.h>
>  #include <unistd.h>
> @@ -382,7 +385,7 @@ static int perf_header__adds_write(struct perf_header *self, int fd)
>  	sec_size = sizeof(*feat_sec) * nr_sections;
>  
>  	sec_start = self->data_offset + self->data_size;
> -	lseek(fd, sec_start + sec_size, SEEK_SET);
> +	lseek64(fd, sec_start + sec_size, SEEK_SET);
>  

Setting _FILE_OFFSET_BITS *and* using O_LARGEFILE, lseek64, etc, is
redundant...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

