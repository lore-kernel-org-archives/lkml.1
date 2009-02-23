Return-Path: <linux-kernel-owner+w=401wt.eu-S1757282AbZBWVks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282AbZBWVks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 16:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752273AbZBWVkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 16:40:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:58935 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbZBWVkj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 16:40:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EpIbQ+cYSv/Wk1tN8DTN0njtQJ5+3umvPOxqPAN8NnWyKlB5A7lLLfIswQIZAQCrBt
         L456iNSETXxKtWKTexir6mDljuAhVScsXlFf6qNsVUYXJcwg32JcT5TSjjtOH8wWXWRh
         yhH5Y8G/0ZjI+RfyVlzm4tM34iWo9GBDQFqjU=
MIME-Version: 1.0
In-Reply-To: <200902232230.29501.rjw@sisk.pl>
References: <8db1092f0902230646o78a07a09t920ad65369b5a20d@mail.gmail.com>
	 <1235419343.4816.27.camel@gaiman> <200902232230.29501.rjw@sisk.pl>
Date: Mon, 23 Feb 2009 22:40:36 +0100
Message-ID: <8db1092f0902231340k7c7d0fd1me49302f2efd03491@mail.gmail.com>
Subject: Re: [Linux 2.6.29-rc6] [drm:i915_set_status_page] *ERROR* can not 
	ioremap virtual address for G33 hw status page
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Eric Anholt <eric@anholt.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "lenb@kernel.org" <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       mjg@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       rui.zhang@intel.com, airlied@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/23 Rafael J. Wysocki <rjw@sisk.pl>:

>
> This is a serious regression on this particular hardware, though.  We need it
> fixed before 2.6.29-final, this way or another.

root@zlom:/usr/src/git/linux-2.6# git bisect bad
6fb88588555a18792a27f483887fe1f2af5f9c9b is first bad commit
commit 6fb88588555a18792a27f483887fe1f2af5f9c9b
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Mon Feb 23 10:08:21 2009 +1000

    drm/i915: fix WC mapping in non-GEM i915 code.

    [airlied - taken from mailing list posting]

    Signed-off-by: Dave Airlie <airlied@redhat.com>

:040000 040000 94fbea685d2937dbe9f3ef861283724262d8443f
451872e14d914a3457adf9c144a705b646d887b4 M      drivers

Revert this commit helps, and Xwindow works, still (like in previous
-rc*) I have this message:
[   16.897361] mtrr: type mismatch for d0000000,10000000 old:
write-back new: write-combining
[   16.897369] [drm] MTRR allocation failed
[   16.897371] .  Graphics performance may suffer.
[   16.897401] pci 0000:00:02.0: irq 27 for MSI/MSI-X
[   16.897432] [drm] Initialized i915 1.6.0 20080730 on minor 0
[   16.931100] mtrr: type mismatch for d0000000,10000000 old:
write-back new: write-combining
[   17.397378] set status page addr 0x00043000

but I don't notice any problems.

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
