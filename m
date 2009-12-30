Return-Path: <linux-kernel-owner+w=401wt.eu-S1752758AbZL3NDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbZL3NDa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 08:03:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbZL3ND3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 08:03:29 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:35626 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbZL3ND2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 08:03:28 -0500
MIME-Version: 1.0
In-Reply-To: <20091228134245.8db992d1.nishimura@mxp.nes.nec.co.jp>
References: <cover.1261858972.git.kirill@shutemov.name>
	 <3f29ccc3c93e2defd70fc1c4ca8c133908b70b0b.1261858972.git.kirill@shutemov.name>
	 <59a7f92356bf1508f06d12c501a7aa4feffb1bbc.1261858972.git.kirill@shutemov.name>
	 <c2379f3965225b6d62e64c64f8c0e67fee085d7f.1261858972.git.kirill@shutemov.name>
	 <7a4e1d758b98ca633a0be06e883644ad8813c077.1261858972.git.kirill@shutemov.name>
	 <20091228134245.8db992d1.nishimura@mxp.nes.nec.co.jp>
Date: Wed, 30 Dec 2009 15:03:25 +0200
Message-ID: <cc557aab0912300503o68035872uedab7f840205b7a3@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] memcg: implement memory thresholds
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: containers@lists.linux-foundation.org, linux-mm@kvack.org,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 28, 2009 at 6:42 AM, Daisuke Nishimura
<nishimura@mxp.nes.nec.co.jp> wrote:
> It would be a nitpick, but my patch(http://marc.info/?l=linux-mm-commits&m=126152804420992&w=2)
> has already modified here.
>
> I think it might be better for you to apply my patches by hand or wait for next mmotm
> to be released to avoid bothering Andrew.
> (There is enough time left till the next merge window :))

I'll rebase it later.

> (snip)
>
>> +static void __mem_cgroup_threshold(struct mem_cgroup *memcg, bool swap)
>> +{
>> +     struct mem_cgroup_threshold_ary *thresholds;
>> +     u64 usage = mem_cgroup_usage(memcg, swap);
>> +     int i, cur;
>> +
> I think calling mem_cgroup_usage() after checking "if(!thresholds)"
> decreases the overhead a little when we don't set any thresholds.
> I've confirmed that the change makes the assembler output different.

Thanks.
