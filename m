Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab0BCReO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 12:34:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34711 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932583Ab0BCReK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 12:34:10 -0500
Message-ID: <4B69B2BD.60909@zytor.com>
Date: Wed, 03 Feb 2010 09:30:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tools: using O_LARGEFILE to open perf data file
  - fix
References: <4B68F32A.9040203@cn.fujitsu.com> <4B6958B8.3000606@cn.fujitsu.com>
In-Reply-To: <4B6958B8.3000606@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2010 03:06 AM, Xiao Guangrong wrote:
>  static void get_next_page(int cpu)
>  {
> -	off64_t save_seek;
> -	off64_t ret;
> +	s64 save_seek;
> +	s64 ret;

Should be off_t (which is 64 bits with _FILE_OFFSET_BITS=64.)

>  
>  	if (!cpu_data[cpu].page)
>  		return;
> @@ -298,9 +298,9 @@ static void get_next_page(int cpu)
>  		update_cpu_data_index(cpu);
>  
>  		/* other parts of the code may expect the pointer to not move */
> -		save_seek = lseek64(input_fd, 0, SEEK_CUR);
> +		save_seek = lseek(input_fd, 0, SEEK_CUR);
>  
> -		ret = lseek64(input_fd, cpu_data[cpu].offset, SEEK_SET);
> +		ret = lseek(input_fd, cpu_data[cpu].offset, SEEK_SET);
>  		if (ret < 0)
>  			die("failed to lseek");

Compare for equality against (off_t)-1 here.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

