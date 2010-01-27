Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575Ab0A0Boc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab0A0Boc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 20:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309Ab0A0Boc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 20:44:32 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57230 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab0A0Bob convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 20:44:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=DluuMk2JKVeCZqJxZIS5Zu16VF7vjQn0qDXGnZKw7Dqng7FDHLriCzDuulfD7ipNuF
         2fxZDlTFj1vdoUC/U1FMj+KbQzlsbnqopPxsTo4LYGz2KycOgdv0377/r5/WTCMnts5v
         fOCdPVB5PW3Hw3g4JxFweRtHsDC7hsHVv6fS4=
MIME-Version: 1.0
In-Reply-To: <20100126160632.3bdbe172.akpm@linux-foundation.org>
References: <c370b092a68e66a2ac6c9d852967d843a1b574c0.1264046338.git.tfransosi@gmail.com>
	 <20100126160632.3bdbe172.akpm@linux-foundation.org>
Date: Tue, 26 Jan 2010 23:44:29 -0200
Message-ID: <a4c8a6d01001261744n37e3472em8e772d9ecf368adf@mail.gmail.com>
Subject: Re: [PATCH] fs/binfmt_elf.c: fix a do-while statement.
From: Thiago Farina <tfransosi@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Roland McGrath <roland@redhat.com>, WANG Cong <amwang@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Tue, Jan 26, 2010 at 10:06 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 20 Jan 2010 23:03:53 -0500
> Thiago Farina <tfransosi@gmail.com> wrote:
>
>> warning: do-while statement is not a compound statement
>>
>> Signed-off-by: Thiago Farina <tfransosi@gmail.com>
>> ---
>>  fs/binfmt_elf.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
>> index edd90c4..75d6468 100644
>> --- a/fs/binfmt_elf.c
>> +++ b/fs/binfmt_elf.c
>> @@ -1404,9 +1404,9 @@ static void fill_auxv_note(struct memelfnote *note, struct mm_struct *mm)
>>  {
>>       elf_addr_t *auxv = (elf_addr_t *) mm->saved_auxv;
>>       int i = 0;
>> -     do
>> +     do {
>>               i += 2;
>> -     while (auxv[i - 2] != AT_NULL);
>> +     } while (auxv[i - 2] != AT_NULL);
>>       fill_note(note, "CORE", NT_AUXV, i * sizeof(elf_addr_t), auxv);
>>  }
>
> hmpf.  Which tool emitted that warning?  sparse?
>
Yes, it is a sparse warning.

> It is somewhat unconventional coding style and it'd be good if
> checkpatch were to warn so that we don't _add_ such things to the tree.
>
> But IMO it's such a minor thing that once it _is_ in the tree, it's not
> really worth the patch noise to go and fix it up.

Yeah, much noise for a small thing. I will not fix more warnings like
this in future.

-Thiago
