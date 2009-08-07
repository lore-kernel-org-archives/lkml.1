Return-Path: <linux-kernel-owner+w=401wt.eu-S1757128AbZHGHyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757128AbZHGHyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 03:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757090AbZHGHyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 03:54:35 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:59678 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757086AbZHGHye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 03:54:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RXGMvwStKw8LkTDpFSJzbGuS0l4iNrPkXVL3GmLerGYMvlajKl3J1OgJ73v2pyZto8
         /SOioI0rUwhIYmxNae3foLGyugIPLBreDIY2tq6Rqlsj8OH9eTFv+w7REtT8qyM86Sm1
         NDvDqS/iNTyZWhPK5ivMd2cC+tEYIxUT4k+Pg=
MIME-Version: 1.0
In-Reply-To: <20090807120857.5BE2.A69D9226@jp.fujitsu.com>
References: <4A7AC201.4010202@redhat.com> <4A7AD6EB.9090208@redhat.com>
	 <20090807120857.5BE2.A69D9226@jp.fujitsu.com>
Date: Fri, 7 Aug 2009 13:24:34 +0530
X-Google-Sender-Auth: 2460932469c9a29c
Message-ID: <661de9470908070054l2fa99ac6w6cac2be63cd5d91f@mail.gmail.com>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 7, 2009 at 8:41 AM, KOSAKI
Motohiro<kosaki.motohiro@jp.fujitsu.com> wrote:
> (cc to memcg folks)
>
>> Avi Kivity wrote:
>> > On 08/06/2009 01:59 PM, Wu Fengguang wrote:
>>
>> >> As a refinement, the static variable 'recent_all_referenced' could be
>> >> moved to struct zone or made a per-cpu variable.
>> >
>> > Definitely this should be made part of the zone structure, consider the
>> > original report where the problem occurs in a 128MB zone (where we can
>> > expect many pages to have their referenced bit set).
>>
>> The problem did not occur in a 128MB zone, but in a 128MB cgroup.
>>
>> Putting it in the zone means that the cgroup, which may have
>> different behaviour from the rest of the zone, due to excessive
>> memory pressure inside the cgroup, does not get the right
>> statistics.
>
> maybe, I heven't catch your point.
>
> Current memcgroup logic also use recent_scan/recent_rotate statistics.
> Isn't it enought?

I don't understand the context, I'll look at the problem when I am
back (I am away from work for the next few days).

Balbir
