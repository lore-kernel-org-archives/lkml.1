Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbZKQKcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbZKQKcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 05:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbZKQKcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 05:32:31 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:63994 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbZKQKca convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 05:32:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=p/VxVNQGwWynsVJACpAr5286+IqXkMPbjTMF9ue4tPynYU6hfN/0OoldkywA1ObKQY
         bmS5WGPQhaWCZOIRm5iOARBO4nzslcIUz1Y3VlxMk2MdH18qqERqS3P5U5dJozHT6csE
         vgjtlNDYKbTDbdmxqOhpDtQUe1rCx2X8f2HWw=
MIME-Version: 1.0
In-Reply-To: <20091117102903.7cb45ff3@lxorguk.ukuu.org.uk>
References: <20091117161551.3DD4.A69D9226@jp.fujitsu.com>
	 <20091117161711.3DDA.A69D9226@jp.fujitsu.com>
	 <20091117102903.7cb45ff3@lxorguk.ukuu.org.uk>
Date: Tue, 17 Nov 2009 19:32:36 +0900
Message-ID: <28c262360911170232i307144cnb4ddea2a5389bd8e@mail.gmail.com>
Subject: Re: [PATCH 2/7] mmc: Don't use PF_MEMALLOC
From: Minchan Kim <minchan.kim@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 7:29 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Tue, 17 Nov 2009 16:17:50 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>
>> Non MM subsystem must not use PF_MEMALLOC. Memory reclaim need few
>> memory, anyone must not prevent it. Otherwise the system cause
>> mysterious hang-up and/or OOM Killer invokation.
>
> So now what happens if we are paging and all our memory is tied up for
> writeback to a device or CIFS etc which can no longer allocate the memory
> to complete the write out so the MM can reclaim ?
>
> Am I missing something or is this patch set not addressing the case where
> the writeback thread needs to inherit PF_MEMALLOC somehow (at least for
> the I/O in question and those blocking it)
>

I agree.
At least, drivers for writeout is proper for using PF_MEMALLOC, I think.


> Alan
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>



-- 
Kind regards,
Minchan Kim
