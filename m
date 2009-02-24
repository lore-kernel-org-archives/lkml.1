Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbZBXBBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbZBXBBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 20:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbZBXBBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 20:01:14 -0500
Received: from rv-out-0506.google.com ([209.85.198.224]:61978 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbZBXBBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 20:01:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=h35zpzv4NbR8zNHnCM4zRmGL3KpouGzCTYSL810LNivkoyi4XbDp+o6z4Elec+iNNA
         qibiA+J/WMq7jKh64cjOeoxHFsJekuHN2JhsRz6afcb6HtOmbU0KFYJevbSXbQEuEgv0
         6QjS0D8tq46/0tuQPe29ndVeAwnnZwBvPhDsY=
MIME-Version: 1.0
In-Reply-To: <8db1092f0902231340k7c7d0fd1me49302f2efd03491@mail.gmail.com>
References: <8db1092f0902230646o78a07a09t920ad65369b5a20d@mail.gmail.com>
	 <1235419343.4816.27.camel@gaiman> <200902232230.29501.rjw@sisk.pl>
	 <8db1092f0902231340k7c7d0fd1me49302f2efd03491@mail.gmail.com>
Date: Mon, 23 Feb 2009 17:01:10 -0800
X-Google-Sender-Auth: 899eea7638542794
Message-ID: <86802c440902231701q1e169a67oa12bd84ac0e4c7aa@mail.gmail.com>
Subject: Re: [Linux 2.6.29-rc6] [drm:i915_set_status_page] *ERROR* can not 
	ioremap virtual address for G33 hw status page
From: Yinghai Lu <yinghai@kernel.org>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Eric Anholt <eric@anholt.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "lenb@kernel.org" <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       mjg@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       rui.zhang@intel.com, airlied@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 1:40 PM, Maciej Rutecki
<maciej.rutecki@gmail.com> wrote:
> 2009/2/23 Rafael J. Wysocki <rjw@sisk.pl>:
>
>>
>> This is a serious regression on this particular hardware, though.  We need it
>> fixed before 2.6.29-final, this way or another.
>
> root@zlom:/usr/src/git/linux-2.6# git bisect bad
> 6fb88588555a18792a27f483887fe1f2af5f9c9b is first bad commit
> commit 6fb88588555a18792a27f483887fe1f2af5f9c9b
> Author: Jesse Barnes <jbarnes@virtuousgeek.org>
> Date:   Mon Feb 23 10:08:21 2009 +1000
>
>    drm/i915: fix WC mapping in non-GEM i915 code.
>
>    [airlied - taken from mailing list posting]
>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> :040000 040000 94fbea685d2937dbe9f3ef861283724262d8443f
> 451872e14d914a3457adf9c144a705b646d887b4 M      drivers
>
> Revert this commit helps, and Xwindow works, still (like in previous
> -rc*) I have this message:
> [   16.897361] mtrr: type mismatch for d0000000,10000000 old:
> write-back new: write-combining
> [   16.897369] [drm] MTRR allocation failed
> [   16.897371] .  Graphics performance may suffer.
> [   16.897401] pci 0000:00:02.0: irq 27 for MSI/MSI-X
> [   16.897432] [drm] Initialized i915 1.6.0 20080730 on minor 0
> [   16.931100] mtrr: type mismatch for d0000000,10000000 old:
> write-back new: write-combining
> [   17.397378] set status page addr 0x00043000

CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1

should help mtrr ones.

please post bootlog with those option set.

YH
