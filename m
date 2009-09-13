Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbZIMQa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbZIMQa3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 12:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbZIMQaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 12:30:24 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:37708 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbZIMQaY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 12:30:24 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Sep 2009 12:30:24 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=a7/oR3i4knhBKFH6efbFlmyIqMfFZ9xLnY3t0zREh62CJl1chvOXvsJUxJeR3XlsNu
         yJJQfIRsTMh0ZDfkd59j8JRA3ORIKE+rNJzcOzEcHOnXKd6U8meYy4xfW+3uz3vSvXNe
         lTN7bvaDGjEgglSjA4BNjgOWCo5rTQoRHLN80=
MIME-Version: 1.0
In-Reply-To: <9EECC02A4CC333418C00A85D21E89326B6611AC5@azsmsx502.amr.corp.intel.com>
References: <20090812074820.GA29631@localhost> <4A843565.3010104@redhat.com>
	 <4A843B72.6030204@redhat.com> <4A843EAE.6070200@redhat.com>
	 <4A846581.2020304@redhat.com> <20090813211626.GA28274@cmpxchg.org>
	 <4A850F4A.9020507@redhat.com> <20090814091055.GA29338@cmpxchg.org>
	 <20090814095106.GA3345@localhost>
	 <9EECC02A4CC333418C00A85D21E89326B6611AC5@azsmsx502.amr.corp.intel.com>
Date: Mon, 14 Sep 2009 01:23:19 +0900
X-Google-Sender-Auth: 028302ad12c00213
Message-ID: <2f11576a0909130923i3795a91bxd0cc0fe7b19a1e3b@mail.gmail.com>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>
Cc: "Wu, Fengguang" <fengguang.wu@intel.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Avi Kivity <avi@redhat.com>,
       Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

> A side note - I've been doing some tracing and shrink_active_list is called a humongous number of times (25000-ish during a ~90 kvm run), with a net result of zero pages moved nearly all the time.  Your test is rescuing essentially all candidate pages from the inactive list.  Right now, I have the VM_EXEC || PageAnon version of your test.

Sorry for the long delayed replay.
I made reproduce environment today. but I don't have luck. I didn't
reproduce stack refault issue.
Could you please explain detailed reproduce way and your analysis way?

My environment is,
  x86_64 CPUx4 MEM 6G
  userland: fedora11
  kernel: latest mmotm

  cgroup size: 128M
  guest mem: 256M
  CONFIG_KSM=n

My result,
  - plenty anon and file fault happen. but it is ideal. it is caused
by demand paging.
  - do_anonymous_page almost doesn't handle stack fault. both host and guest.
