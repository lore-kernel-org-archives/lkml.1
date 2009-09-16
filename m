Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbZIPLRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbZIPLRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 07:17:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbZIPLRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 07:17:51 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33188 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbZIPLRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 07:17:51 -0400
Message-ID: <1bc66b163326564dafb5a7dd8959fd56.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <2375c9f90909160235m1f052df0qb001f8243ed9291e@mail.gmail.com>
References: <2375c9f90909160235m1f052df0qb001f8243ed9291e@mail.gmail.com>
Date: Wed, 16 Sep 2009 20:17:52 +0900 (JST)
Subject: Re: kcore patches (was Re: 2.6.32 -mm merge plans)
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: Am=?ISO-2022-JP?B?P3JpY29fV2FuZw==?= <xiyou.wangcong@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Américo_Wang さんは書きました：
> On Wed, Sep 16, 2009 at 7:15 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>>#kcore-fix-proc-kcores-statst_size.patch: is it right?
>>kcore-fix-proc-kcores-statst_size.patch
>
> Hmm, I think KAMEZAWA Hiroyuki's patchset is a much better fix for this.
> Hiroyuki?
>
Hmm ? My set is not agaisnt "file size" of /proc/kcore.

One problem of this patch is..this makes size of /proc/kcore as 0 bytes.
Then, objdump cannot read this. (it checks file size.)
readelf can read this. (it ignores file size.)

I wonder what you mention is.... because we know precise kclist_xxx
after my series, we can calculate kcore's size in precise by
get_kcore_size().

It seems /proc's inode->i_size is "static" and we cannot
provides return value of get_kcore_size() directly. It may need
some work and should depends on my kclist_xxx patch sets which are not
in merge candidates. If you can wait, I'll do some work for fixing this
problem. (but will not be able to merge directly against upstream.)

But for now, we have to use some fixed value....and using above
patch for 2.6.31 is not very bad.

Thanks,
-Kame

