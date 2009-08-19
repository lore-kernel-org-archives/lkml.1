Return-Path: <linux-kernel-owner+w=401wt.eu-S1751320AbZHSJBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320AbZHSJBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 05:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbZHSJBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 05:01:17 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:60582 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbZHSJBQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 05:01:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SRvZL4bpxSejg3HZZSqm4sxz1JmmKvcE4fLpt70qPL3AUnvJq2MPaW95w0B90XwB3s
         s4N25FAMgtCGVmedJtgzkXyzdUFFE2daLJ/WtCUaQgHvILN6sgmT+QogG7VQ4On083R1
         olRbgIzwQe+SEEt3AQalsweO36LIjAgzXMrrk=
MIME-Version: 1.0
In-Reply-To: <20090818083024.GB31469@csn.ul.ie>
References: <alpine.LFD.2.00.0908172346460.32114@casper.infradead.org>
	 <20090818083024.GB31469@csn.ul.ie>
Date: Wed, 19 Aug 2009 21:01:17 +1200
Message-ID: <202cde0e0908190201p4c2e2701xf18bdecbc53df905@mail.gmail.com>
Subject: Re: HTLB mapping for drivers. Driver example
From: Alexey Korolev <akorolex@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Alexey Korolev <akorolev@infradead.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel,


>
> This seems a lot of burden to put on a device driver, particularly with
> respect to the reservations.

Thanks a lot for review you did. That is right.  I don't like this
burden as well.
>
>> File operations of /dev/hpage_map do the following:
>>
>> In file open we  associate mappings of /dev/xxx with the file on hugetlbfs (like it is done in ipc/shm.c)
>>       file->f_mapping = h_file->f_mapping;
>>
>> In get_unmapped_area we should tell about addressing constraints in case of huge pages by calling hugetlbfs procedures. (as in ipc/shm.c)
>>       return get_unmapped_area(h_file, addr, len, pgoff, flags);
>>
>> We need to let hugetlbfs do architecture specific operations with mapping in mmap call. This driver does not reserve any memory for private mappings
>> so driver requests reservation from hugetlbfs. (Actually driver can do this as well but it will make it more complex)
>>
>> The exit procedure:
>> * removes memory from page cache
>> * deletes file on hugetlbfs vfs mount
>> *  free pages
>>
>> Application example is not shown here but it is very simple. It does the following: open file /dev/hpage_map, mmap a region, read/write memory, unmap file, close file.
>>
>
> For the use-model you have in mind, could you look at Eric Munson's patches
> and determine if the target application would have been happy to call the
> following please?
>
> mmap(0, len, prot, MAP_ANONYMOUS|MAP_HUGETLB, 0, 0)
>
Hmm. But how can I at least identify which driver this call is addressed to?

Thanks,
Alexey
