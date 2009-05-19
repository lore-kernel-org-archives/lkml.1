Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467AbZESPz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbZESPz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 11:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbZESPzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 11:55:22 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:46186 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbZESPzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 11:55:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZohIoV+hl82evj1sfaCJdvxLfO+SRrWujlqVIWMIE92O8n+xjoKrN94dlYXHgcMZsG
         Qb3HJoxtjrmQ2qMX/H6W5bJrZa7Pv4iHaMgOzqfWRKim47ApDtfQrEuxO97gk7drKgGv
         Mky6niryGcGfL0qvBKX49eVaZaC9uUTWriXlI=
MIME-Version: 1.0
In-Reply-To: <4A12B30D.9040002@redhat.com>
References: <20090519161756.4EE4.A69D9226@jp.fujitsu.com>
	 <20090519074925.GA690@localhost>
	 <20090519170208.742C.A69D9226@jp.fujitsu.com>
	 <20090519085354.GB2121@localhost> <4A12B30D.9040002@redhat.com>
Date: Wed, 20 May 2009 00:55:22 +0900
X-Google-Sender-Auth: 754ca8a910c4f2de
Message-ID: <2f11576a0905190855j658a608en36f52e8eecfdf6fd@mail.gmail.com>
Subject: Re: [PATCH 2/3] vmscan: make mapped executable pages the first class 
	citizen
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
       Peter Zijlstra <peterz@infradead.org>, "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Another (amazing) finding of the test is, only around 1/10 mapped pages
>> are actively referenced in the absence of user activities.
>>
>> Shall we protect the remaining 9/10 inactive ones? This is a question ;-)
>
> I believe we already do, due to the active list not being
> scanned if none of the streaming IO pages get promoted to
> the active list.

his workload is,

lseek(0)
read(110 * 4096)
lseek(100 * 4096)
read(110 * 4096)
lseek(200 * 4096)
read(110 * 4096)
....

IOW, 90% pages move into inactive list, 10% (overlapped readed) pages
move into active list.
he think it is file server simulation.

I don't know it is good simulation or not.
