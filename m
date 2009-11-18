Return-Path: <linux-kernel-owner+w=401wt.eu-S1751540AbZKRLWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbZKRLWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 06:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbZKRLWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 06:22:17 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:43445 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbZKRLWQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 06:22:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xrj/HL42HZEK3Mlimlc7eYpWBs11Vh0KlGgM1NQyUz2oIaAKV05GOioUxKN8irRJlh
         +klq7FJW9SQzfrz4v7yyA9CoMU+F2LCQ/epA6U/N1GsAa3jWTxSEGGsC3s6mGaoE+WE2
         tmyg870ASief5RcqEchk/6n/JUywAvIHf0wXk=
MIME-Version: 1.0
In-Reply-To: <873a4c5d4y.fsf@basil.nowhere.org>
References: <1258531548-5015-1-git-send-email-leoli@freescale.com>
	 <873a4c5d4y.fsf@basil.nowhere.org>
Date: Wed, 18 Nov 2009 19:22:22 +0800
X-Google-Sender-Auth: 8cf2f5f4924f1b1b
Message-ID: <2a27d3730911180322i5a0dce3ds7deee6e96c6733b9@mail.gmail.com>
Subject: Re: [RFC] char/mem: Honor O_SYNC over intelligent setting of uncached 
	access
From: Li Yang <leoli@freescale.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 6:41 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Li Yang <leoli@freescale.com> writes:
>
> D> The original code will automatially set the page non-cacheable if the mmap'ped
>> address is not in kernel managed low memory.
>>
>> We already have O_SYNC flag to pass the cacheability settings.   Therefore we should
>> honor the case that O_SYNC is delibrately not used.  For example, it is useful to the
>> case that not all system memory is managed by Linux, and want to be mmaped cacheable.
>>
>> Not sure if there is anything out there depending on the previous behavior.
>
> Very likely there is. That change seems rather dangerous.
>
> If you wanted to do something like this you would need a long
> deprecation period with printks and format warnings. But most likely
> it's not worth it, what advantage does the change have?

The general advantage is that user has the true control of the page
cacheability through O_SYNC file open() flag.  For the previous way,
kernel might map memory as non-cacheable when it's not necessary.  One
most common use case is that, user could limit the memory managed by
kernel and mmap the memory manually.  But he can't make that VMA
cacheable.  The user should have a better idea than kernel if a
certain memory space is I/O or not when using mmap().

- Leo
