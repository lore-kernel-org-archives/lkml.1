Return-Path: <linux-kernel-owner+w=401wt.eu-S1752250Ab0ADArN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab0ADArN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 19:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490Ab0ADArM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 19:47:12 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:59368 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab0ADArM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 19:47:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HoY4+GpPcI1ruOu6O8xryiyn0dylb7z8VPwhI9ZIS37Zehpf60yZ7OKOODS/eRQNGp
         flWL9mXIoFS2l7gfmrVZMuFF/EUZC9Ys3Ej4DkTT9yzugwO38oYzuLG8KyyMnbc91fI3
         Vt0pDhZ8oc58Et8UV6pJuUHL01Ecfe8elaU4A=
MIME-Version: 1.0
In-Reply-To: <20100104084347.c36d9855.kamezawa.hiroyu@jp.fujitsu.com>
References: <ceeec51bdc2be64416e05ca16da52a126b598e17.1258773030.git.minchan.kim@gmail.com>
	 <ae2928fe7bb3d94a7ca18d3b3274fdfeb009803a.1258773030.git.minchan.kim@gmail.com>
	 <4B38876F.6010204@gmail.com>
	 <alpine.LSU.2.00.0912301619500.3369@sister.anvils>
	 <20100104084347.c36d9855.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 4 Jan 2010 09:47:11 +0900
Message-ID: <28c262361001031647r602fcdbeve56dbf4da4e31254@mail.gmail.com>
Subject: Re: [PATCH 2/3 -mmotm-2009-12-10-17-19] Count zero page as file_rss
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 4, 2010 at 8:43 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 30 Dec 2009 16:49:52 +0000 (GMT)
> Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:
>
>> > >
>> > > Kame reported following as
>> > > "Before starting zero-page works, I checked "questions" in lkml and
>> > > found some reports that some applications start to go OOM after zero-page
>> > > removal.
>> > >
>> > > For me, I know one of my customer's application depends on behavior of
>> > > zero page (on RHEL5). So, I tried to add again it before RHEL6 because
>> > > I think removal of zero-page corrupts compatibility."
>> > >
>> > > So how about adding zero page as file_rss again for compatibility?
>>
>> I think not.
>>
>> KAMEZAWA-san can correct me (when he returns in the New Year) if I'm
>> wrong, but I don't think his customer's OOMs had anything to do with
>> whether the ZERO_PAGE was counted in file_rss or not: the OOMs came
>> from the fact that many pages were being used up where just the one
>> ZERO_PAGE had been good before.  Wouldn't he have complained if the
>> zero_pfn patches hadn't solved that problem?
>>
>> You are right that I completely overlooked the issue of whether to
>> include the ZERO_PAGE in rss counts (now being a !vm_normal_page,
>> it was just natural to leave it out); and I overlooked the fact that
>> it used to be counted into file_rss in the old days (being !PageAnon).
>>
>> So I'm certainly at fault for that, and thank you for bringing the
>> issue to attention; but once considered, I can't actually see a good
>> reason why we should add code to count ZERO_PAGEs into file_rss now.
>> And if this patch falls, then 1/3 and 3/3 would fall also.
>>
>> And the patch below would be incomplete anyway, wouldn't it?
>> There would need to be a matching change to zap_pte_range(),
>> but I don't see that.
>>
>> We really don't want to be adding more and more ZERO_PAGE/zero_pfn
>> tests around the place if we can avoid them: KOSAKI-san has a strong
>> argument for adding such a test in kernel/futex.c, but I don't the
>> argument here.
>>
>
> I agree that ZERO_PAGE shouldn't be counted as rss. Now, I feel that old
> counting method(in old zero-page implementation) was bad.
>
> Minchan-san, I'm sorry for noise.

That's all right.
It was my mistake.

I will drop this and repost Matt and Hugh's ACK version.
Thanks for all. :)

>
> Thanks,
> -Kame
>
>
>
>



-- 
Kind regards,
Minchan Kim
