Return-Path: <linux-kernel-owner+w=401wt.eu-S1752582AbYHRIWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbYHRIWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 04:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbYHRIWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 04:22:22 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:27026 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbYHRIWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 04:22:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sS2+HNufPm3umFEALTHiUNwbHORQOF7RVse7rdQdk7ra/caVAfLN0VnvsXAQV7p4Nx
         LKOleTjQ27L5yqb34kOcSPP2S6B/BzGEHlkVQVuvK2Rn7GWcUgpUVFNDCBaLgtuD8Q+U
         a8vJ07EH1b8zTSlyzlOJ6LHJN4ZKNhrUOpf8U=
Message-ID: <45a44e480808180122g6f3f83bdh28b8fb0e6f5038db@mail.gmail.com>
Date: Mon, 18 Aug 2008 04:22:20 -0400
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Ian Campbell" <ijc@hellion.org.uk>
Subject: Re: kernel BUG at lib/radix-tree.c:473!
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>, "Hugh Dickins" <hugh@veritas.com>,
       "Johannes Weiner" <hannes@saeurebad.de>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       "Kel Modderman" <kel@otaku42.de>,
       "Markus Armbruster" <armbru@redhat.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <1219046079.3996.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218697362.26014.9.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0808150049110.17216@blonde.site>
	 <1218989974.3996.4.camel@localhost.localdomain>
	 <200808181132.43718.nickpiggin@yahoo.com.au>
	 <1219046079.3996.11.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 3:54 AM, Ian Campbell <ijc@hellion.org.uk> wrote:
> On Mon, 2008-08-18 at 11:32 +1000, Nick Piggin wrote:
>> On Monday 18 August 2008 02:19, Ian Campbell wrote:
>> > FWIW the patch below apparently makes it work for me, but I'm not going
>> > to pretend I follow what's going on, why or what else it breaks ;-)
>>
>> I think Iwould prefer fs_defio to use its own set_page_dirty
>> function. __set_page_dirty_no_writeback is supposed to be used
>> on pagecache, by filesystems.
>
> fbdefio: add set_page_dirty handler to deferred IO FB
>
> Fixes kernel BUG at lib/radix-tree.c:473.
>
> Previously the handler was incidentally provided by tmpfs but this was
> removed with:
>
>  commit 14fcc23fdc78e9d32372553ccf21758a9bd56fa1
>  Author: Hugh Dickins <hugh@veritas.com>
>  Date:   Mon Jul 28 15:46:19 2008 -0700
>
>    tmpfs: fix kernel BUG in shmem_delete_inode
>
> relying on this behaviour was incorrect in any case and the BUG
> also appeared when the device node was on an ext3 filesystem.
>
> Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
> Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
> Cc: Nick Piggin <nickpiggin@yahoo.com.au>
> Cc: Hugh Dickins <hugh@veritas.com>
> Cc: Johannes Weiner <hannes@saeurebad.de>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Kel Modderman <kel@otaku42.de>
> Cc: Markus Armbruster <armbru@redhat.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>

Acked-by: Jaya Kumar <jayakumar.lkml@gmail.com>

Thanks,
jaya
