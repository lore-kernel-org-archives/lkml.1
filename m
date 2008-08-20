Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbYHTIC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbYHTIC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 04:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbYHTICG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 04:02:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:53911 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbYHTICD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 04:02:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SLePh/8T+5q6ho3cWVKmejsQvKJBwtxJcB+P7EyAK9kPDUxYpgPfhGj7RogR5WJsZU
         RwNkzQfhpCRZTJEDn4cjPMjZxJtf38DYyoFkaHKXfN2bhWr0yda7x3Gcqowdv2fgCBCB
         cERpLtyJwRmMezLLDowhzgQ6gCZoyLzsFEVDY=
Message-ID: <86802c440808200102n6487ae17ud790991b8ea30d16@mail.gmail.com>
Date: Wed, 20 Aug 2008 01:02:02 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bill Fink" <billfink@mindspring.com>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
Cc: "David Witbrodt" <dawitbro@sbcglobal.net>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, netdev <netdev@vger.kernel.org>
In-Reply-To: <20080820035130.38426b00.billfink@mindspring.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <109483.89278.qm@web82104.mail.mud.yahoo.com>
	 <86802c440808192221s3ada5443qc3b9d8e26f252d03@mail.gmail.com>
	 <20080820035130.38426b00.billfink@mindspring.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 12:51 AM, Bill Fink <billfink@mindspring.com> wrote:
> On Tue, 19 Aug 2008, Yinghai Lu wrote:
>
>> On Tue, Aug 19, 2008 at 9:51 PM, David Witbrodt <dawitbro@sbcglobal.net> wrote:
>> > While reading drivers/char/hpet.c and looking at the functions
>> > used there, I discovered request_region(), and realized that it
>> > would be difficult to compare the entire iomem_resource tree to
>> > a dummy tree only containing resources added by insert_resource()
>> > and request_resource().  It might be simpler to have my tiny
>> > e820_reserve_resources() replacement add each resource to 3 trees
>> > -- the real iomem_resource tree, and 2 dummy trees -- which could
>> > then be compared for differences just before the kernel locks up.
>>
>> with reverting patch that change insert_resource to request_resource...
>> 2.6.26 or 2.6.27-rcX still hange somewhere.
>
> This is true if he reverted just the 3def3d6d... commit, but if he
> also reverts the similar, and immediately following, 1e934dda...
> commit, then his 2.6.26 kernel runs fine.

interesting,

David, can you try only comment out

late_initcall(lapic_insert_resource);

YH
