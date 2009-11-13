Return-Path: <linux-kernel-owner+w=401wt.eu-S1752611AbZKMMld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbZKMMld (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 07:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbZKMMl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 07:41:29 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:65531 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbZKMMl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 07:41:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Y9YvWJZkgip6Ve0FWEaWfS0mf3S+YmSDtMFt5CLxm81EzOgaa0b6rEsK3OsdH0Bti4
         orUd8A1Zo0LfZPQRlPosUTG1q/vHWTXSQ+6wnubJBcdB3PROlmA4Kg0/z2Kylz3Qi/Gn
         KCbHZXtIv/zsEAFAtabxrxiIJrHdT+cSnKLIU=
MIME-Version: 1.0
In-Reply-To: <1258054235-3208-6-git-send-email-mel@csn.ul.ie>
References: <1258054235-3208-1-git-send-email-mel@csn.ul.ie>
	 <1258054235-3208-6-git-send-email-mel@csn.ul.ie>
Date: Fri, 13 Nov 2009 21:41:33 +0900
Message-ID: <28c262360911130441h24e45cd8l60e5e10aed0d3650@mail.gmail.com>
Subject: Re: [PATCH 5/5] vmscan: Take order into consideration when deciding 
	if kswapd is in trouble
From: Minchan Kim <minchan.kim@gmail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, Frans Pop <elendil@planet.nl>,
       Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org\"" <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 4:30 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> If reclaim fails to make sufficient progress, the priority is raised.
> Once the priority is higher, kswapd starts waiting on congestion.
> However, on systems with large numbers of high-order atomics due to
> crappy network cards, it's important that kswapd keep working in
> parallel to save their sorry ass.
>
> This patch takes into account the order kswapd is reclaiming at before
> waiting on congestion. The higher the order, the longer it is before
> kswapd considers itself to be in trouble. The impact is that kswapd
> works harder in parallel rather than depending on direct reclaimers or
> atomic allocations to fail.
>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

It's make sense to me.
It can help high order atomic allocation which is a big problem of allocator. :)

Thanks Mel.

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
