Return-Path: <linux-kernel-owner+w=401wt.eu-S1753824AbZIATl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbZIATl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 15:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbZIATl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 15:41:58 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:39535 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbZIATl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 15:41:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=x3Zn2afBSEOLe/JvVbeqsNb1tnZYXfmWepr1DJa87qrgXC7RUXa075nUM5swaqZ7B9
         E7fcoxKVaS+b4zcNLAbzkvp9LmsayIbQXe3iVqLEl6TysbrOMK7pyY7rT4VhazCw7tUS
         23EIGdul/hTjLwl6hbcuLXyX8o+wFD0fOyhoc=
Date: Tue, 1 Sep 2009 23:41:54 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Rakib Mullick <rakib.mullick@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [Question] x86,APIC: In apicdef.h dfr,svr,...... shouldn't be
	const?
Message-ID: <20090901194154.GB19964@lenovo>
References: <b9df5fa10908312248x6a8946f5jfbe972f3358baad3@mail.gmail.com> <aa79d98a0909010143t27096d25n1ee36651f8487b52@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa79d98a0909010143t27096d25n1ee36651f8487b52@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Tue, Sep 01, 2009 at 12:43:06PM +0400]
| On 9/1/09, Rakib Mullick <rakib.mullick@gmail.com> wrote:
| > Hello guys, Intel System programmers guide says - dfr, svr, esr - this
| > registers should be readonly. So shouldn't they use const? Or is it
| > anything else?
| 
| Hi Rakib, i dont have sources under my hands at moment, but iirc there
| were situations we nees to poke esr register.
| 
| >
| > And apicdef.h also contains a style problem, checkpatch warns about
| > following style:
| >
| >               u32	spurious_vector	:  8
| >
| > Check patch wants as:
| >
| >                          u32	spurious_vector:8
| >
| > Shouldn't this issues be fixed?
| >
| > Thanks,
| > --
| 
| i dont see reason why not ;)
| though i wonder why we need this structure at all. We may have
| extended amd entries.
| Yinghai cced.
| 

Ingo, Yinghai, Suresh,

is there any particular reason we keep apicdef.h:struct local_apic at all?

Was there some plan on this structure usage in future? If take into
account amd extended registers this structure doesn't cover all
possible cases. And at moment we do poke apic registers via APIC_
macros mostly and it seems that is the more convenient
and flexible approach. The only thing I may imagine where we
could (possibly) use it in future is suspend/resume cases.

But perhaps I miss something?

	-- Cyrill
