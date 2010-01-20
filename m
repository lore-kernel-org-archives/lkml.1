Return-Path: <linux-kernel-owner+w=401wt.eu-S1755699Ab0ATHH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab0ATHH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 02:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013Ab0ATHH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 02:07:26 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56358 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751324Ab0ATHHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 02:07:23 -0500
Message-ID: <4B56ABB6.9080802@cn.fujitsu.com>
Date: Wed, 20 Jan 2010 15:07:34 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>, linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@suse.de>,
       Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] scsi: add __print_hex() to ftrace
References: <4B56A60F.6060207@jp.fujitsu.com> <1263970573.18117.96.camel@Joe-Laptop.home>
In-Reply-To: <1263970573.18117.96.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Wed, 2010-01-20 at 15:43 +0900, Kei Tokunaga wrote:
>> diff -puN kernel/trace/trace_output.c~ftrace_print_hex kernel/trace/trace_output.c
>> --- linux-2.6.33-rc4-trace/kernel/trace/trace_output.c~ftrace_print_hex	2010-01-14 19:55:45.000000000 +0900
>> +++ linux-2.6.33-rc4-trace-kei/kernel/trace/trace_output.c	2010-01-14 20:02:49.000000000 +0900
>> @@ -355,6 +355,21 @@ ftrace_print_symbols_seq(struct trace_se
>>  }
>>  EXPORT_SYMBOL(ftrace_print_symbols_seq);
>>  
>> +const char *
>> +ftrace_print_hex_seq(struct trace_seq *p, const unsigned char *buf, int buf_len)
>> +{
>> +	int i;
>> +	const char *ret = p->buffer + p->len;
>> +
>> +	for (i = 0; i < buf_len; i++)
>> +		trace_seq_printf(p, "%s%2.2x", i == 0 ? "" : " ", buf[i]);
>> +
>> +	trace_seq_putc(p, 0);
> 
> hex_dump_to_buffer?
> 

hex_dump_to_buffer has some limitations. For example, you have to specify:

	@rowsize: number of bytes to print per line; must be 16 or 32

We can change hex_dump_to_buffer() to fit our needs, but let us do
that later.

