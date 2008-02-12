Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbYBLW7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbYBLW7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752213AbYBLW7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:59:13 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49521 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751597AbYBLW7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:59:10 -0500
Date: Tue, 12 Feb 2008 14:56:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com, marcelo@kvack.org,
       daniel.spang@gmail.com, riel@redhat.com, alan@lxorguk.ukuu.org.uk,
       linux-fsdevel@vger.kernel.org, pavel@ucw.cz, a1426z@gawab.com,
       jonathan@jonmasters.org, zlynx@acm.org
Subject: Re: [PATCH 4/8][for -mm] mem_notify v6: memory_pressure_notify()
 caller
Message-Id: <20080212145651.69cc34a5.akpm@linux-foundation.org>
In-Reply-To: <2f11576a0802090724s679258c4g7414e0a6983f4706@mail.gmail.com>
References: <2f11576a0802090724s679258c4g7414e0a6983f4706@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Feb 2008 00:24:28 +0900
"KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com> wrote:

> the notification point to happen whenever the VM moves an
> anonymous page to the inactive list - this is a pretty good indication
> that there are unused anonymous pages present which will be very likely
> swapped out soon.
> 
> and, It is judged out of trouble at the fllowing situations.
>  o memory pressure decrease and stop moves an anonymous page to the
> inactive list.
>  o free pages increase than (pages_high+lowmem_reserve)*2.

This seems rather arbitrary.  Why choose this stage in the page
reclaimation process rather than some other stage?

If this feature is useful then I'd expect that some applications would want
notification at different times, or at different levels of VM distress.  So
this semi-randomly-chosen notification point just won't be strong enough in
real-world use.

Does this change work correctly and appropriately for processes which are
running in a cgroup memory controller?

Given the amount of code which these patches add, and the subsequent
maintenance burden, and the unlikelihood of getting many applications to
actually _use_ the interface, it is not obvious to me that inclusion in the
kernel is justifiable, sorry.


memory_pressure_notify() is far too large to be inlined.

Some of the patches were wordwrapped.


