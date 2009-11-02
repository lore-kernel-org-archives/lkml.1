Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbZKBPbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbZKBPbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 10:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755445AbZKBPbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 10:31:42 -0500
Received: from gv-out-0910.google.com ([216.239.58.190]:27058 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438AbZKBPbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 10:31:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=kYV23jVMfGC5HDFzry55uOu6jVDjwfLrWG+HhDFopb5LyWJlVqDKy+gjuomXCsBSmU
         YQVIcMSCiu6cmk2lMoDNEWnFbioGaJUcZltWJeegs0JsXiNB13XOK3Ol7ZB2SPfRvyRn
         5j8MwJU60bNk7/kfntZIA+cJxssruAgmqS1mI=
Message-ID: <4AEEFB5D.9080009@gmail.com>
Date: Mon, 02 Nov 2009 16:31:41 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5pre) Gecko/20091028 SUSE/3.0b4-5.1 Thunderbird/3.0pre
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: npiggin@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 1/1] MM: slqb, fix per_cpu access
References: <1257113578-1584-1-git-send-email-jirislaby@gmail.com> <200911022353.30524.rusty@rustcorp.com.au>
In-Reply-To: <200911022353.30524.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.97b
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2009 02:23 PM, Rusty Russell wrote:
>> --- a/mm/slqb.c
>> +++ b/mm/slqb.c
>> @@ -2770,16 +2770,16 @@ static DEFINE_PER_CPU(struct delayed_work, cache_trim_work);
>>  
>>  static void __cpuinit start_cpu_timer(int cpu)
>>  {
>> -	struct delayed_work *cache_trim_work = &per_cpu(cache_trim_work, cpu);
>> +	struct delayed_work *_cache_trim_work = &per_cpu(cache_trim_work, cpu);
>>  
>>  	/*
>>  	 * When this gets called from do_initcalls via cpucache_init(),
>>  	 * init_workqueues() has already run, so keventd will be setup
>>  	 * at that time.
>>  	 */
>> -	if (keventd_up() && cache_trim_work->work.func == NULL) {
>> -		INIT_DELAYED_WORK(cache_trim_work, cache_trim_worker);
>> -		schedule_delayed_work_on(cpu, cache_trim_work,
>> +	if (keventd_up() && _cache_trim_work->work.func == NULL) {
>> +		INIT_DELAYED_WORK(_cache_trim_work, cache_trim_worker);
>> +		schedule_delayed_work_on(cpu, _cache_trim_work,
>>  					__round_jiffies_relative(HZ, cpu));
> 
> How about calling the local var "trim"?
> 
> This actually makes the code more readable, IMHO.

Please ignore this version of the patch. After this I sent a new one
which changes the global var name.

So the local variable is untouched there. If you want me to perform the
cleanup, let me know. In any case I'd make it trim_work instead of trim
which makes more sense to me.
