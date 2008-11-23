Return-Path: <linux-kernel-owner+w=401wt.eu-S1758521AbYKWK7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521AbYKWK7U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 05:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757128AbYKWK7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 05:59:10 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:16145 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967AbYKWK7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 05:59:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Q4ubdJ1dn78f54jJCtDCqI72PStQfdH7/wQ62aGmgCIejAduCKQPO3/VSW3d471u8K
         zJ0QZ0VMxX01L/TuKyMnW/CEU8///xoe9tABw8jgt0bkBeljlA0YlxYwTxUNxrnI6TT/
         pJEKRXRWGFmSG+UpsFKP+FmKl12N6eXdCFMYM=
Message-ID: <49293777.8070404@gmail.com>
Date: Sun, 23 Nov 2008 12:59:03 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: srostedt@redhat.com, a.p.zijlstra@chello.nl, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Subject: Re: [PATCH 2/3] tracing/stack-tracer: fix locking
References: <20081123085310.GF30453@elte.hu> <1227436748-17075-2-git-send-email-edwintorok@gmail.com> <20081123105211.GC30453@elte.hu>
In-Reply-To: <20081123105211.GC30453@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-11-23 12:52, Ingo Molnar wrote:
> * Török Edwin <edwintorok@gmail.com> wrote:
>
>   
>> +		down_read(&mm->mmap_sem);
>> +		vma = find_vma(mm, ip);
>>  		if (vma) {
>>  			file = vma->vm_file;
>>  			vmstart = vma->vm_start;
>>  		}
>> +		up_read(&mm->mmap_sem);
>>  	}
>>  	if (file) {
>>  		ret = trace_seq_path(s, &file->f_path);
>>     
>
> and now it's "file" that is held without a reference and possibly 
> racy.
>   

I'll move the (file) inside the mmap_sem too, since file is part of vma,
and you need mmap_sem to access the vma
nobody can modify (file) if they don't hold mmap_sem.
Am I right?

--Edwin
