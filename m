Return-Path: <linux-kernel-owner+w=401wt.eu-S2992579AbXCWV4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992579AbXCWV4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 17:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934324AbXCWV4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 17:56:19 -0400
Received: from smtp-out.google.com ([216.239.45.13]:47553 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934322AbXCWV4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 17:56:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=aDgYxtu/Vf7SIMrgpG6xHIAPFdfGWWafKq2BS7zOo7TNHNKgiZvzUnyz7mkm0fRmC
	4UZUxTsihH1vUmCZUrIiA==
Message-ID: <b040c32a0703231456u298186c6o1ec7199bfdbe7f65@mail.gmail.com>
Date: Fri, 23 Mar 2007 14:56:07 -0700
From: "Ken Chen" <kenchen@google.com>
To: "William Lee Irwin III" <wli@holomorphy.com>
Subject: Re: [patch] rfc: introduce /dev/hugetlb
Cc: "Adam Litke" <agl@us.ibm.com>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070323150346.GU2986@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b040c32a0703230144r635d7902g2c36ecd7f412be31@mail.gmail.com>
	 <20070323150346.GU2986@holomorphy.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/23/07, William Lee Irwin III <wli@holomorphy.com> wrote:
> I like this patch a lot, though I'm not likely to get around to testing
> it today. If userspace testcode is available that would be great to see
> posted so I can just boot into things and run that.

Here is the test code that I used:
(warning: x86 centric)

#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <sys/mman.h>

#define SIZE	(4*1024*1024UL)

int main(void)
{
	int fd;
	long i;
	char *addr;

	fd = open("/dev/hugetlb", O_RDWR);
	if (fd == -1) {
		perror("open failure");
		exit(1);
	}

	addr = mmap(0, SIZE, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
	if (addr == MAP_FAILED) {
		perror("mmap failure");
		exit(2);
	}

	for (i = 0; i < SIZE; i+=4096)
		addr[i] = 1;

	printf("success!\n");
}
