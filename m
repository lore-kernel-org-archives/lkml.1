Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbXJII75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbXJII75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 04:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbXJII7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 04:59:50 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:24704 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751184AbXJII7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 04:59:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BzpxoQufbaqoiLNed3fhEqjz7LQ0JW72eVGvmWmd1foYr2ptpBeVxdxaWsKdMRQnsyAhes2Hh2ddNzgj/QFW3Z9dGIZ6uIXDR3NriA1JeKmDJlXq+rHkRuuMjRSic0O8ZBdUza3eK7vOA7CGdZFd1XkdlucBD85Wr9Wxn2Lx2sc=  ;
X-YMail-OSG: VVR2u1QVM1l8pi2hSLGVpDx4JPqNHLZUr6Byt.h0pMfawFK_zJVwCKthiDGhd9d28bY3WsK8GA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH -mm -v4 1/3] i386/x86_64 boot: setup data
Date: Tue, 9 Oct 2007 02:28:09 +1000
User-Agent: KMail/1.9.5
Cc: linux-mm@kvack.org, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
References: <1191912010.9719.18.camel@caritas-dev.intel.com> <200710090206.22383.nickpiggin@yahoo.com.au> <1191920123.9719.71.camel@caritas-dev.intel.com>
In-Reply-To: <1191920123.9719.71.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710090228.09841.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 October 2007 18:55, Huang, Ying wrote:
> On Tue, 2007-10-09 at 02:06 +1000, Nick Piggin wrote:

> > I'm just wondering whether you really need to access highmem in
> > boot code...
>
> Because the zero page (boot_parameters) of i386 boot protocol has 4k
> limitation, a linked list style boot parameter passing mechanism (struct
> setup_data) is proposed by Peter Anvin. The linked list is provided by
> bootloader, so it is possible to be in highmem region.

OK. I don't really know the code, but I trust you ;)


> > Definitely on most architectures it would just amount to
> > memcpy(dst, __va(phys), n);, right? However I don't know if
>
> Yes.
>
> > it's worth the trouble of overriding it unless there is some
> > non-__init user of it.
>
> To support debugging and kexec, the boot parameters include the linked
> list above are exported into sysfs. This function is used there too. The
> patch is the No. 2 of the series.

Ah, I see. I missed that.

OK, well rather than make it weak, and have everyone except
i386 override it, can you just ifdef CONFIG_HIGHMEM?

After that, I guess most other architectures wouldn't even
use the function. Maybe it can go into lib/ instead so that
it can be discarded by the linker if it isn't used?
