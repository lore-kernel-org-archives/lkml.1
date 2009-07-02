Return-Path: <linux-kernel-owner+w=401wt.eu-S1756382AbZGBJi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382AbZGBJi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 05:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbZGBJiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 05:38:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60923 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbZGBJiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 05:38:16 -0400
Message-ID: <4A4C808A.9010302@redhat.com>
Date: Thu, 02 Jul 2009 17:40:26 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, roland@redhat.com,
       serue@us.ibm.com, dhowells@redhat.com, jmorris@namei.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [Patch 2/3] elf: clean up fill_note_info()
References: <20090701050840.6188.84560.sendpatchset@localhost.localdomain>	<20090701050850.6188.59496.sendpatchset@localhost.localdomain> <20090701122955.da45e073.akpm@linux-foundation.org>
In-Reply-To: <20090701122955.da45e073.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 1 Jul 2009 01:06:36 -0400
> Amerigo Wang <amwang@redhat.com> wrote:
>
>   
>> +#define	NUM_NOTES	6
>>  	info->notes = kmalloc(NUM_NOTES * sizeof(struct memelfnote),
>>  			      GFP_KERNEL);
>> +#undef NUM_NOTES
>>     
>
> That #define amounts to a really perverse code comment.
>
> How about we do this?
>   


Ah, better! No problem for me.

Thank you!
> --- a/fs/binfmt_elf.c~elf-clean-up-fill_note_info-fix
> +++ a/fs/binfmt_elf.c
> @@ -1719,10 +1719,8 @@ static int elf_note_info_init(struct elf
>  	memset(info, 0, sizeof(*info));
>  	INIT_LIST_HEAD(&info->thread_list);
>  
> -#define	NUM_NOTES	6
> -	info->notes = kmalloc(NUM_NOTES * sizeof(struct memelfnote),
> -			      GFP_KERNEL);
> -#undef NUM_NOTES
> +	/* Allocate space for six ELF notes */
> +	info->notes = kmalloc(6 * sizeof(struct memelfnote), GFP_KERNEL);
>  	if (!info->notes)
>  		return 0;
>  	info->psinfo = kmalloc(sizeof(*info->psinfo), GFP_KERNEL);
> _
>
>   

