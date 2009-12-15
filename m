Return-Path: <linux-kernel-owner+w=401wt.eu-S1757942AbZLOHsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942AbZLOHsO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 02:48:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756414AbZLOHsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 02:48:13 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:35073 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbZLOHsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 02:48:12 -0500
MIME-Version: 1.0
In-Reply-To: <20091215103517.75645536.kamezawa.hiroyu@jp.fujitsu.com>
References: <cover.1260571675.git.kirill@shutemov.name>
	 <ca59c422b495907678915db636f70a8d029cbf3a.1260571675.git.kirill@shutemov.name>
	 <c1847dfb5c4fed1374b7add236d38e0db02eeef3.1260571675.git.kirill@shutemov.name>
	 <747ea0ec22b9348208c80f86f7a813728bf8e50a.1260571675.git.kirill@shutemov.name>
	 <20091212125046.14df3134.d-nishimura@mtf.biglobe.ne.jp>
	 <cc557aab0912120506x56b9a707ob556035fdcf40a22@mail.gmail.com>
	 <20091212233409.60da66fb.d-nishimura@mtf.biglobe.ne.jp>
	 <cc557aab0912121146y276a8d26v8baee15be1f83a97@mail.gmail.com>
	 <20091215103517.75645536.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 15 Dec 2009 09:48:09 +0200
Message-ID: <cc557aab0912142348j6d0f6206qd751f74e416c6710@mail.gmail.com>
Subject: Re: [PATCH RFC v2 3/4] memcg: rework usage of stats by soft limit
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: nishimura@mxp.nes.nec.co.jp, containers@lists.linux-foundation.org,
       linux-mm@kvack.org, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 3:35 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Sat, 12 Dec 2009 21:46:08 +0200
> "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
>
>> On Sat, Dec 12, 2009 at 4:34 PM, Daisuke Nishimura
>> <d-nishimura@mtf.biglobe.ne.jp> wrote:
>> > On Sat, 12 Dec 2009 15:06:52 +0200
>> > "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
>> >
>> >> On Sat, Dec 12, 2009 at 5:50 AM, Daisuke Nishimura
>> >> <d-nishimura@mtf.biglobe.ne.jp> wrote:
>> >> > And IIUC, it's the same for your threshold feature, right ?
>> >> > I think it would be better:
>> >> >
>> >> > - discard this change.
>> >> > - in 4/4, rename mem_cgroup_soft_limit_check to mem_cgroup_event_check,
>> >> >  and instead of adding a new STAT counter, do like:
>> >> >
>> >> >        if (mem_cgroup_event_check(mem)) {
>> >> >                mem_cgroup_update_tree(mem, page);
>> >> >                mem_cgroup_threshold(mem);
>> >> >        }
>> >>
>> >> I think that mem_cgroup_update_tree() and mem_cgroup_threshold() should be
>> >> run with different frequency. How to share MEM_CGROUP_STAT_EVENTS
>> >> between soft limits and thresholds in this case?
>> >>
>> > hmm, both softlimit and your threshold count events at the same place(charge and uncharge).
>> > So, I think those events can be shared.
>> > Is there any reason they should run in different frequency ?
>>
>> SOFTLIMIT_EVENTS_THRESH is 1000. If use the same value for thresholds,
>> a threshold can
>> be exceed on 1000*nr_cpu_id pages. It's too many. I think, that 100 is
>> a reasonable value.
>>
>
> Hmm, then what amount of costs does this code add ?
>
> Do you have benchmark result ?

I've post some numbers how the patchset affects performance:
http://article.gmane.org/gmane.linux.kernel.mm/41880

Do you need any other results?
