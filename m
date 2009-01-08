Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbZAHH6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbZAHH6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 02:58:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbZAHH54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 02:57:56 -0500
Received: from smtp-out.google.com ([216.239.45.13]:46282 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbZAHH5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 02:57:55 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=k+J9oVrxLWBbzqmEK/+frmsHqUa2cNDajXbb2vy6TLo0/4NtpfAhdADXbvnFqcQVX
	hWa4+/p88FhJBKz/h90tQ==
MIME-Version: 1.0
In-Reply-To: <20090108134014.BFB2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <6991.1231194895@turing-police.cc.vt.edu>
	 <604427e00901072018o42ff0627yb5282f2a81a13c65@mail.gmail.com>
	 <20090108134014.BFB2.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Date: Wed, 7 Jan 2009 23:57:52 -0800
Message-ID: <604427e00901072357xbe39b1bu3e9f956640ede322@mail.gmail.com>
Subject: Re: 2.6.29 -mm merge plans
From: Ying Han <yinghan@google.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Mike Waychison <mikew@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.76
X-GMailtapped: yinghan
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yes. the change is in the last few lines of the patch. I found out
that the flags was set as FAULT_FLAG_WRITE no matter what(write/read)
whence FAULT_FLAG_RETRY is set. the new patch changed the logic which
only set the flag in the "write" case.

@@ -2713,8 +2720,10 @@ static int do_linear_fault(struct mm_struct *mm, struct
 {
       pgoff_t pgoff = (((address & PAGE_MASK)
                       - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
-       unsigned int flags = (write_access ? FAULT_FLAG_WRITE : 0);

+       int write = write_access & ~FAULT_FLAG_RETRY;
+       unsigned int flags = (write ? FAULT_FLAG_WRITE : 0);

--Ying


On Wed, Jan 7, 2009 at 8:41 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> Hi Valdis:
>>      Please try this fix and i tested on ubunbu8.10 with xmms and it helps.
>>
>
> Hi, Ying-san
> Could you please explain which was wrong and how to fix.
>
>
>
>
>
