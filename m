Return-Path: <linux-kernel-owner+w=401wt.eu-S1755050AbYKBV2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbYKBV2v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 16:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167AbYKBV2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 16:28:43 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:19095 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbYKBV2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 16:28:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZYuL3BMOc2YjvJ1fUOI0SGyZDT0rzygNEIV0/QIOsLZwvpGFPGmlLsy2C06yDPvlNJ
         pFqTRAajrtOOz7+4nY1JyRPNCmgvjvLLUPe9gbeNa1lA/hZ9dxrbMymIOUyUvmH8r0+X
         MUuSFQdaK0RC96eP2/HAy0d7Le4DBxCcqGiR0=
Message-ID: <490E1B74.6010904@gmail.com>
Date: Sun, 02 Nov 2008 23:28:20 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: mingo@elte.hu, srostedt@redhat.com, a.p.zijlstra@chello.nl,
       sandmann@daimi.au.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Identify which executable object the userspace address
 belongs to. Store thread group leader id, and use it to lookup the address
 in the process's map. We could have looked up the address on thread's map,
 but the thread might not exist by the time we are called. The process might
 not exist either, but if you are reading trace_pipe, that is unlikely.
References: <1225660694-19765-1-git-send-email-edwintorok@gmail.com> <1225660694-19765-2-git-send-email-edwintorok@gmail.com> <1225660694-19765-3-git-send-email-edwintorok@gmail.com> <20081102212512.GF28946@ZenIV.linux.org.uk>
In-Reply-To: <20081102212512.GF28946@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-11-02 23:25, Al Viro wrote:
> On Sun, Nov 02, 2008 at 11:18:14PM +0200, T??r??k Edwin wrote:
>   
>> +static int
>> +trace_seq_path(struct trace_seq *s, struct path *path)
>> +{
>> +	int ret;
>> +	struct seq_file m;
>> +	m.count = s->len;
>> +	m.size = PAGE_SIZE;
>> +	m.buf = s->buffer;
>> +	ret = seq_path(&m, path, "\n");
>> +	if (ret)
>> +		s->len = m.count;
>> +	return ret;
>> +}
>>     
>
> NAK.  seq_path() is a blatantly wrong thing to use here.
>   

Are there any alternatives I could use?

This function is called when I do 'cat /sys/kernel/debug/trace', not
during tracing itself.

Best regards,
--Edwin
