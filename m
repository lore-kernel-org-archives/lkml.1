Return-Path: <linux-kernel-owner+w=401wt.eu-S1757028AbZCFVza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028AbZCFVza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 16:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbZCFVzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 16:55:19 -0500
Received: from smtp-out.google.com ([216.239.45.13]:41846 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbZCFVzR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 16:55:17 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=iP/yCInyWNiD9upeAEnYsBCpkO9NT0A1EMGw6zG36tpn5NDGXvcxvlZn2vdNfiDjJ
	6J/k4SyFBddj+2Nias6Ow==
MIME-Version: 1.0
In-Reply-To: <20090306211832.GV15340@beardog.cca.cpqcorp.net>
References: <20090306085529.GP11787@kernel.dk>
	 <20090306181302X.fujita.tomonori@lab.ntt.co.jp>
	 <20090306092114.GS11787@kernel.dk>
	 <20090306182705P.fujita.tomonori@lab.ntt.co.jp>
	 <20090306093520.GV11787@kernel.dk>
	 <20090306143856.GT15340@beardog.cca.cpqcorp.net>
	 <da824cf30903061259j4a37ab7cneea308c736da469d@mail.gmail.com>
	 <20090306211832.GV15340@beardog.cca.cpqcorp.net>
Date: Fri, 6 Mar 2009 13:55:13 -0800
Message-ID: <da824cf30903061355m4e5368b0q938776cf5d61a46a@mail.gmail.com>
Subject: Re: [PATCH] hpsa: SCSI driver for HP Smart Array controllers
From: Grant Grundler <grundler@google.com>
To: scameron@beardog.cca.cpqcorp.net
Cc: Jens Axboe <jens.axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, mike.miller@hp.com,
       akpm@linux-foundation.org, linux-scsi@vger.kernel.org,
       coldwell@redhat.com, hare@novell.com, iss_storagedev@hp.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 6, 2009 at 1:18 PM,  <scameron@beardog.cca.cpqcorp.net> wrote:
> On Fri, Mar 06, 2009 at 12:59:48PM -0800, Grant Grundler wrote:
>> On Fri, Mar 6, 2009 at 6:38 AM,  <scameron@beardog.cca.cpqcorp.net> wrote:
>> ...
>> > The command buffers have to be in the first 4GB of memory, as the command
>> > register is only 32 bits, so they are allocated by pci_alloc_consistent.
>>
>> Huh?!!
>> ISTR the mpt2sas driver is indicating it can handle 64-bit DMA masks for
>> both streaming and control data. I need to double check to be sure of that.
>
> it is something specific to smart array.  The command register that we
> stuff the bus address of the command into is only 32 bits wide.  Everything
> else it does is 64 bits.

Sorry...I'm spacing out and confusing my drivers.

thanks,
grant

>>
>> > However, the chained SG lists don't have that limitation, so I think they
>> > can be kmalloc'ed, and so not chew up and unreasonable amount of the
>> > pci_alloc_consistent memory and get a larger number of SGs.   ...right?
>> > Maybe that's the better way to do it.
>>
>> I thought the driver was tracking this and using the appropriate construct
>> based on which DMA mask is in effect.
>
> The DMA mask is insufficiently expressive to describe the limitations and
> capabilities of the Smart array.  There's no way to describe with a single
> DMA mask that the command register is 32-bits, but everything else is 64
> bits.
>
> -- steve
>
>
