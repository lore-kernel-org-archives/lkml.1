Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058Ab0AYWTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab0AYWTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 17:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033Ab0AYWTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 17:19:46 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:36429 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab0AYWTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 17:19:45 -0500
Message-ID: <4B5E1868.6090204@bx.jp.nec.com>
Date: Mon, 25 Jan 2010 17:17:12 -0500
From: Keiichi KII <k-keiichi@bx.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: linux-kernel@vger.kernel.org, lwoodman@redhat.com, linux-mm@kvack.org,
       mingo@elte.hu, tzanussi@gmail.com, riel@redhat.com,
       akpm@linux-foundation.org, fweisbec@gmail.com,
       Munehiro Ikeda <m-ikeda@ds.jp.nec.com>,
       Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
Subject: Re: [RFC PATCH -tip 1/2 v2] add tracepoints for pagecache
References: <4B5A3D00.8080901@bx.jp.nec.com>	 <4B5A3DD5.3020904@bx.jp.nec.com> <1264213709.31321.401.camel@gandalf.stny.rr.com>
In-Reply-To: <1264213709.31321.401.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010年01月22日 21:28), Steven Rostedt wrote:
>> +TRACE_EVENT(remove_from_page_cache,
>> +
>> +	TP_PROTO(struct address_space *mapping, pgoff_t offset),
>> +
>> +	TP_ARGS(mapping, offset),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(dev_t, s_dev)
>> +		__field(ino_t, i_ino)
>> +		__field(pgoff_t, offset)
>> +		),
>> +
>> +	TP_fast_assign(
>> +		__entry->s_dev = mapping->host->i_sb->s_dev;
>> +		__entry->i_ino = mapping->host->i_ino;
>> +		__entry->offset = offset;
>> +		),
>> +
>> +	TP_printk("s_dev=%u:%u i_ino=%lu offset=%lu", MAJOR(__entry->s_dev),
>> +		MINOR(__entry->s_dev), __entry->i_ino, __entry->offset)
>> +);
>> +
> 
> The above qualify in converting to templates or DECLACE_TRACE_CLASS, and
> DEFINE_EVENT, That is, rename the above TRACE_EVENT into
> DECLARE_TRACE_CLASS, and then have the other one be a DEFINE_EVENT().
> See the trace/event/sched.h for examples.
> 
> The TRACE_EVENT can add a bit of code, so use DECLARE_TRACE_CLASS when
> possible and it will save on the size overhead.

Thank you for your information. I'll fix it next time.

Thanks,
Keiichi
