Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbZFIITo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbZFIITo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 04:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759258AbZFIITY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 04:19:24 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:36625 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758902AbZFIITV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 04:19:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HwG6gipSwNVHhysz3meT3j0ag2iOqEnvceerK9SlUy5HGqLueb7xEChEFVb3B4AjHf
         KY69VRD5wbHu5jIXX9Pidh0zD09/47wGq/lSXcwiZJR1PPr7meYK/zdHPnddmoWEI08n
         OykJSXa+c75cx+lpa3immtSYQkxPY//1FxhUE=
MIME-Version: 1.0
In-Reply-To: <20090609164850.DD73.A69D9226@jp.fujitsu.com>
References: <20090609161925.DD70.A69D9226@jp.fujitsu.com>
	 <28c262360906090048x792fb3f9i6678298b693f6c5a@mail.gmail.com>
	 <20090609164850.DD73.A69D9226@jp.fujitsu.com>
Date: Tue, 9 Jun 2009 17:19:20 +0900
Message-ID: <28c262360906090119r6e881caq9b74028ba43567a7@mail.gmail.com>
Subject: Re: [PATCH mmotm] vmscan: handle may_swap more strictly (Re: [PATCH 
	mmotm] vmscan: fix may_swap handling for memcg)
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 9, 2009 at 4:58 PM, KOSAKI
Motohiro<kosaki.motohiro@jp.fujitsu.com> wrote:
>> Hi, KOSAKI.
>>
>> As you know, this problem caused by if condition(priority) in shrink_zone.
>> Let me have a question.
>>
>> Why do we have to prevent scan value calculation when the priority is zero ?
>> As I know, before split-lru, we didn't do it.
>>
>> Is there any specific issue in case of the priority is zero ?
>
> Yes.
>
> example:
>
> get_scan_ratio() return anon:80%, file=20%. and the system have
> 10000 anon pages and 10000 file pages.
>
> shrink_zone() picked up 8000 anon pages and 2000 file pages.
> it mean 8000 file pages aren't scanned at all.
>
> Oops, it can makes OOM-killer although system have droppable file cache.
>
Hmm..Can that problem be happen in real system ?
The file ratio is big means that file lru list scanning is so big but
rotate is small.
It means file lru have few reclaimable page.

Isn't it ? I am confusing.
Could you elaborate, please if you don't mind ?

-- 
Kinds regards,
Minchan Kim
