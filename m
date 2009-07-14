Return-Path: <linux-kernel-owner+w=401wt.eu-S1754331AbZGNRuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbZGNRuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 13:50:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbZGNRuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 13:50:14 -0400
Received: from smtp-out.google.com ([216.239.33.17]:21414 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987AbZGNRuN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 13:50:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=C1QPSkLZT8Cpbu8yhDlO1EETvqyo+n4N2xlS9pqR7JeydRYE5F5fAYvdQyZdygXvU
	8LYnSBec876ZXTCp5cTIQ==
MIME-Version: 1.0
In-Reply-To: <1247593652.13426.15938.camel@nimitz>
References: <20090710230043.16778.29656.stgit@hastromil.mtv.corp.google.com>
	 <20090713150303.70ab5176.kamezawa.hiroyu@jp.fujitsu.com>
	 <2f86c2480907130827u7d2b062bw26bbb80a8e3de657@mail.gmail.com>
	 <20090714084950.2401d9a6.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830907132050n226aecb3ucab6746a4d0e81fa@mail.gmail.com>
	 <20090714125334.b476aa78.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830907132104o55d31ccexb15e5aa35c31416e@mail.gmail.com>
	 <20090714132538.ac0bc44a.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830907141028y50f36d63h8ea06f73ff369591@mail.gmail.com>
	 <1247593652.13426.15938.camel@nimitz>
Date: Tue, 14 Jul 2009 10:50:02 -0700
Message-ID: <6599ad830907141050r1e9dde98l56afd37629f749e8@mail.gmail.com>
Subject: Re: [PATCH 3/3] Quick vmalloc vs kmalloc fix to the case where array 
	size is too large
From: Paul Menage <menage@google.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Benjamin Blum <bblum@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 10:47 AM, Dave Hansen<dave@linux.vnet.ibm.com> wrote:
>
> How big were those allocations that were failing?  The code made it
> appear that order-2 (PAGE_SIZE*4) allocations were failing.  That's a
> bit lower than I'd expect the page allocator to start failing.

I think it depends on how much fragmentation you've got.

We've seen it fail for cpusets with (I guess) hundreds or thousands of threads.

Paul
