Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbXJIOBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbXJIOBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 10:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbXJIOBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 10:01:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:45399 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbXJIOA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 10:00:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EChM52HF5/lKYe20kyTTG5Nal5jthH5NZ/hGut4pIk9/+z7dFPsLe30ydmdAPhsWkZe8k/epb1Llp9GmISvJI+jdGOtxh3WKGxXUFRBZjqQs/9DyFb4MaPu4e3roDkdlToqRbVkVMIWaMTOR+v+XrVqcTvXhv7kpm1U83dzb83k=
Message-ID: <851fc09e0710090700u21b2db91yca2d5e88cb7a502a@mail.gmail.com>
Date: Tue, 9 Oct 2007 22:00:57 +0800
From: "huang ying" <huang.ying.caritas@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH -mm -v4 1/3] i386/x86_64 boot: setup data
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Huang, Ying" <ying.huang@intel.com>, linux-mm@kvack.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Chandramouli Narayanan" <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200710091313.45003.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1191912010.9719.18.camel@caritas-dev.intel.com>
	 <200710090125.27263.nickpiggin@yahoo.com.au>
	 <200710091313.45003.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/9/07, Andi Kleen <ak@suse.de> wrote:
>
> > Care to add a line of documentation if you keep it in mm/memory.c?
>
> It would be better to just use early_ioremap() (or ioremap())
>
> That is how ACPI who has similar issues accessing its tables solves this.

Yes. That is another solution. But there is some problem about
early_ioremap (boot_ioremap, bt_ioremap for i386) or ioremap.

- ioremap can not be used before mem_init.
- For i386, boot_ioremap can map at most 4 pages, bt_ioremap can map
at most 16 pages. This will be an unnecessary constrains for size of
setup_data.
- For i386, the virtual memory space of ioremap is limited too.

Best Regards,
Huang Ying
