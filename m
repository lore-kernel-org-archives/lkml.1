Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbZEMFwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbZEMFwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 01:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbZEMFwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 01:52:07 -0400
Received: from iona.labri.fr ([147.210.8.143]:35261 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbZEMFwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 01:52:06 -0400
Message-ID: <4A0A600F.9010801@inria.fr>
Date: Wed, 13 May 2009 07:52:15 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] migration: only migrate_prep() once per move_pages()
References: <49E58D7A.4010708@ens-lyon.org> <20090415164955.41746866.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090415164955.41746866.kamezawa.hiroyu@jp.fujitsu.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Wed, 15 Apr 2009 09:32:10 +0200
> Brice Goglin <Brice.Goglin@ens-lyon.org> wrote:
>
>   
>> migrate_prep() is fairly expensive (72us on 16-core barcelona 1.9GHz).
>> Commit 3140a2273009c01c27d316f35ab76a37e105fdd8 improved move_pages()
>> throughput by breaking it into chunks, but it also made migrate_prep()
>> be called once per chunk (every 128pages or so) instead of once per
>> move_pages().
>>
>> This patch reverts to calling migrate_prep() only once per chunk
>> as we did before 2.6.29.
>> It is also a followup to commit 0aedadf91a70a11c4a3e7c7d99b21e5528af8d5d
>>     mm: move migrate_prep out from under mmap_sem
>>
>> This improves migration throughput on the above machine from 600MB/s
>> to 750MB/s.
>>
>> Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>
>>
>>     
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> I think this patch is good. page migration is best-effort syscall ;)
>   

Since nobody complained about this patch, may I get a Ack and get the
patch merged for 2.6.31?

thanks,
Brice

