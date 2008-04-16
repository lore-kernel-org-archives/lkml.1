Return-Path: <linux-kernel-owner+w=401wt.eu-S1764678AbYDPOop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764678AbYDPOop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 10:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756226AbYDPOoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 10:44:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755586AbYDPOog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 10:44:36 -0400
Message-ID: <48060EFE.3000107@redhat.com>
Date: Wed, 16 Apr 2008 10:36:46 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: David Wilder <dwilder@us.ibm.com>, Tom Zanussi <zanussi@comcast.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] relayfs: support larger relay buffer
References: <4804C95F.2080204@redhat.com> <84144f020804160133ye2327b8wb3774e1e0ccf6ff8@mail.gmail.com>
In-Reply-To: <84144f020804160133ye2327b8wb3774e1e0ccf6ff8@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

Pekka Enberg wrote:
> On Tue, Apr 15, 2008 at 6:27 PM, Masami Hiramatsu <mhiramat@redhat.com> wrote:
>> Use vmalloc() and memset() instead of kcalloc() to allocate a page* array
>>  when the array size is bigger than one page. This enables relayfs to support
>>  bigger relay buffers than 64MB on 4k-page system, 512MB on 16k-page system.
>>
>>  Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
>>  ---
>>  @@ -130,7 +138,10 @@ static void *relay_alloc_buf(struct rcha
>>   depopulate:
>>         for (j = 0; j < i; j++)
>>                 __free_page(buf->page_array[j]);
>>  -       kfree(buf->page_array);
>>  +       if (pa_size > PAGE_SIZE)
> 
> You can use is_vmalloc_addr() here.

Thank you for your good advice!
I'll use that.

> 
>>  +               vfree(buf->page_array);
>>  +       else
>>  +               kfree(buf->page_array);
>>         return NULL;
>>   }
>>

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

