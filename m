Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbZAMSB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbZAMSB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 13:01:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbZAMSBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 13:01:48 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38197 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbZAMSBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 13:01:47 -0500
Message-ID: <496CD735.9040102@us.ibm.com>
Date: Tue, 13 Jan 2009 12:02:29 -0600
From: Maynard Johnson <maynardj@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH 02/18] oprofile: rename cpu buffer functions
References: <1231366655-17837-1-git-send-email-robert.richter@amd.com> <1231366655-17837-3-git-send-email-robert.richter@amd.com>
In-Reply-To: <1231366655-17837-3-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Richter wrote:
> This patch renames cpu buffer functions to something more oprofile
> specific names. Functions will be moved to the global name space.
I'm not seeing where these functions are moved to the global name space, either in this set of 18 patches or the next set of 9 patches.  Is that in some patch set that is yet to be posted?
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  drivers/oprofile/buffer_sync.c |   10 +++++-----
>  drivers/oprofile/cpu_buffer.c  |    4 ++--
>  drivers/oprofile/cpu_buffer.h  |   10 +++++-----
>  3 files changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
> index 737bd94..d295d92 100644
> --- a/drivers/oprofile/buffer_sync.c
> +++ b/drivers/oprofile/buffer_sync.c
> @@ -331,7 +331,7 @@ static void add_ibs_begin(int cpu, int code, struct mm_struct *mm)
>  	off_t offset;
>  	struct op_sample *sample;
> 
> -	sample = cpu_buffer_read_entry(cpu);
> +	sample = op_cpu_buffer_read_entry(cpu);
>  	if (!sample)
>  		goto Error;
>  	rip = sample->eip;
> @@ -370,7 +370,7 @@ static void add_ibs_begin(int cpu, int code, struct mm_struct *mm)
>  		count = IBS_OP_CODE_SIZE;	/*IBS OP is 5 int64s*/
> 
>  	for (i = 0; i < count; i++) {
> -		sample = cpu_buffer_read_entry(cpu);
> +		sample = op_cpu_buffer_read_entry(cpu);
>  		if (!sample)
>  			goto Error;
>  		add_event_entry(sample->eip);
> @@ -537,11 +537,11 @@ void sync_buffer(int cpu)
> 
>  	add_cpu_switch(cpu);
> 
> -	cpu_buffer_reset(cpu);
> -	available = cpu_buffer_entries(cpu);
> +	op_cpu_buffer_reset(cpu);
> +	available = op_cpu_buffer_entries(cpu);
> 
>  	for (i = 0; i < available; ++i) {
> -		struct op_sample *s = cpu_buffer_read_entry(cpu);
> +		struct op_sample *s = op_cpu_buffer_read_entry(cpu);
>  		if (!s)
>  			break;
> 
> diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
> index fcf96f6..e52c085 100644
> --- a/drivers/oprofile/cpu_buffer.c
> +++ b/drivers/oprofile/cpu_buffer.c
> @@ -152,14 +152,14 @@ add_sample(struct oprofile_cpu_buffer *cpu_buf,
>  	struct op_entry entry;
>  	int ret;
> 
> -	ret = cpu_buffer_write_entry(&entry);
> +	ret = op_cpu_buffer_write_entry(&entry);
>  	if (ret)
>  		return ret;
> 
>  	entry.sample->eip = pc;
>  	entry.sample->event = event;
> 
> -	ret = cpu_buffer_write_commit(&entry);
> +	ret = op_cpu_buffer_write_commit(&entry);
>  	if (ret)
>  		return ret;
> 
> diff --git a/drivers/oprofile/cpu_buffer.h b/drivers/oprofile/cpu_buffer.h
> index aacb0f0..83d491e 100644
> --- a/drivers/oprofile/cpu_buffer.h
> +++ b/drivers/oprofile/cpu_buffer.h
> @@ -64,7 +64,7 @@ DECLARE_PER_CPU(struct oprofile_cpu_buffer, cpu_buffer);
>   * reset these to invalid values; the next sample collected will
>   * populate the buffer with proper values to initialize the buffer
>   */
> -static inline void cpu_buffer_reset(int cpu)
> +static inline void op_cpu_buffer_reset(int cpu)
>  {
>  	struct oprofile_cpu_buffer *cpu_buf = &per_cpu(cpu_buffer, cpu);
> 
> @@ -72,7 +72,7 @@ static inline void cpu_buffer_reset(int cpu)
>  	cpu_buf->last_task = NULL;
>  }
> 
> -static inline int cpu_buffer_write_entry(struct op_entry *entry)
> +static inline int op_cpu_buffer_write_entry(struct op_entry *entry)
>  {
>  	entry->event = ring_buffer_lock_reserve(op_ring_buffer_write,
>  						sizeof(struct op_sample),
> @@ -88,13 +88,13 @@ static inline int cpu_buffer_write_entry(struct op_entry *entry)
>  	return 0;
>  }
> 
> -static inline int cpu_buffer_write_commit(struct op_entry *entry)
> +static inline int op_cpu_buffer_write_commit(struct op_entry *entry)
>  {
>  	return ring_buffer_unlock_commit(op_ring_buffer_write, entry->event,
>  					 entry->irq_flags);
>  }
> 
> -static inline struct op_sample *cpu_buffer_read_entry(int cpu)
> +static inline struct op_sample *op_cpu_buffer_read_entry(int cpu)
>  {
>  	struct ring_buffer_event *e;
>  	e = ring_buffer_consume(op_ring_buffer_read, cpu, NULL);
> @@ -111,7 +111,7 @@ static inline struct op_sample *cpu_buffer_read_entry(int cpu)
>  }
> 
>  /* "acquire" as many cpu buffer slots as we can */
> -static inline unsigned long cpu_buffer_entries(int cpu)
> +static inline unsigned long op_cpu_buffer_entries(int cpu)
>  {
>  	return ring_buffer_entries_cpu(op_ring_buffer_read, cpu)
>  		+ ring_buffer_entries_cpu(op_ring_buffer_write, cpu);

