Return-Path: <linux-kernel-owner+w=401wt.eu-S1756403AbYGXNnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403AbYGXNnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 09:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752713AbYGXNnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 09:43:12 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:43370 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbYGXNnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 09:43:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nac2bUx33sLkZhB1MN3norYY7pVHFhp+zGTLRhc9k3C5vSPZrsyvWqTPvHz2SOfMq1
         YeXWwWGiEHyP/lq6Kut4TMYo5b4UkZu+16TyxmtQ/C+v+K1pZoVQodWjcvemBg/mQsbS
         rek+1fFGOZZGcaRR9DbUUMeI+Uw4Z2I8YdTc4=
Message-ID: <4a4634330807240643j6eb3314am343efe6c37992b50@mail.gmail.com>
Date: Thu, 24 Jul 2008 08:43:11 -0500
From: "Shirish Pargaonkar" <shirishpargaonkar@gmail.com>
To: "Steve French" <smfrench@gmail.com>
Subject: Re: cifs: suggestions for a few more sparse warnings
Cc: "Harvey Harrison" <harvey.harrison@gmail.com>,
       "Jeff Layton" <jlayton@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <524f69650807231839g399f57a8ied548d81eefdbebd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216860920.30386.55.camel@brick>
	 <524f69650807231839g399f57a8ied548d81eefdbebd@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve,

On Wed, Jul 23, 2008 at 8:39 PM, Steve French <smfrench@gmail.com> wrote:
> On Wed, Jul 23, 2008 at 7:55 PM, Harvey Harrison
> <harvey.harrison@gmail.com> wrote:
>> Here's a patch for some of the other warnings, but the cifsacl.c bit
>> needs a comment I think.
>>
>> Harvey
>>
>> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
>> index 34902cf..70f0ef5 100644
>> --- a/fs/cifs/cifsacl.c
>> +++ b/fs/cifs/cifsacl.c
>> @@ -169,8 +169,7 @@ static void copy_sec_desc(const struct cifs_ntsd *pntsd,
>>        for (i = 0; i < 6; i++)
>>                ngroup_sid_ptr->authority[i] = group_sid_ptr->authority[i];
>>        for (i = 0; i < 5; i++)
>> -               ngroup_sid_ptr->sub_auth[i] =
>> -                               cpu_to_le32(group_sid_ptr->sub_auth[i]);
>> +               cpu_to_le32s(&group_sid_ptr->sub_auth[i]);
>>
>>        return;
>>  }
>
> No - the cifsacl one looks like just a bug - there should not be an
> endian conversion here.
>

I think you are right, there should not be any conversion since the
sub authorities would be in little endin format when we did get_cifs_acl
prior to this copy.


> Shirish,
> Would you verify?
>
> --
> Thanks,
>
> Steve
>
