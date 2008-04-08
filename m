Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075AbYDHGiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbYDHGiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 02:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbYDHGiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 02:38:00 -0400
Received: from smtp-out.google.com ([216.239.33.17]:49533 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbYDHGh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 02:37:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=oQvR8rwwxcw3kGQMM5AZrRBygZtB5QbE48DhPK9HxhLRrvWErMzU6WD6Lrax0d3OD
	Am3VzQV83RsgIRpIY66MA==
Message-ID: <6599ad830804072337g2e7b4613hdcc05062dc2ca4e0@mail.gmail.com>
Date: Mon, 7 Apr 2008 23:37:43 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [-mm] Add an owner to the mm_struct (v8)
Cc: "Pavel Emelianov" <xemul@openvz.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       "David Rientjes" <rientjes@google.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47F861C8.7080700@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080404080544.26313.38199.sendpatchset@localhost.localdomain>
	 <47F5F3FA.7060709@linux.vnet.ibm.com>
	 <6599ad830804041211r37848a6coaa900d8bdac40fbe@mail.gmail.com>
	 <47F79102.6090406@linux.vnet.ibm.com>
	 <6599ad830804051023v69caa3d4h6e26ccb420bca899@mail.gmail.com>
	 <47F7BB69.3000502@linux.vnet.ibm.com>
	 <6599ad830804051057n2f2802e4w6179f2e108467494@mail.gmail.com>
	 <47F7CC08.4090209@linux.vnet.ibm.com>
	 <6599ad830804051629k3649dbc4na92bb3d0cd7a0492@mail.gmail.com>
	 <47F861C8.7080700@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 5, 2008 at 10:38 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>  >
>  > How long does the test run for? How many threads does each client have?
>
>  The test on each client side runs for about 10 seconds. I saw the client create
>  up to 411 threads.
>

I'm not convinced that an application that creates 400 threads and
exits in 10 seconds is particular representative of a high-performance
application.

But I agree that it's an example of something it may be worth trying
to optimize for.

You mention that you saw tgid exits - what order did the individual
threads exit in? If we threw the mm to the last thread in the thread
group rather than the first, would that help?

Paul
