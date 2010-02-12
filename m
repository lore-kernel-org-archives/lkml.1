Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842Ab0BLCiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 21:38:15 -0500
Received: from mail-pz0-f172.google.com ([209.85.222.172]:43082 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757817Ab0BLCiN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 21:38:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=x5z4O5BDL8TyU+NW/PrjUDFkaJH+thyXxiIp18rQdT5ZMueAN3ZeDw+4ZAkOIQNMPO
         P8qQDe83eMeAj4P4UtRkfiJU0W9lpGGaZdSplExRGc26OT/JEbJyD2hDkYq5kX1aI0WQ
         0rtuLIy697XWAj3H6nbONsTjcEZRGAfOKAlNY=
MIME-Version: 1.0
In-Reply-To: <4B74524D.8080804@nortel.com>
References: <4B71927D.6030607@nortel.com>
	 <20100210093140.12D9.A69D9226@jp.fujitsu.com>
	 <4B72E74C.9040001@nortel.com>
	 <28c262361002101645g3fd08cc7t6a72d27b1f94db62@mail.gmail.com>
	 <4B74524D.8080804@nortel.com>
Date: Fri, 12 Feb 2010 11:38:12 +0900
Message-ID: <28c262361002111838q7db763feh851a9bea4fdd9096@mail.gmail.com>
Subject: Re: tracking memory usage/leak in "inactive" field in /proc/meminfo?
From: Minchan Kim <minchan.kim@gmail.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Balbir Singh <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 3:54 AM, Chris Friesen <cfriesen@nortel.com> wrote:
> That just makes the comparison even worse...it means that there is more
> memory in active/inactive that isn't accounted for in any other category
> in /proc/meminfo.

Hmm. It's very strange. It's impossible if your kernel and drivers is normal.
Could you grep sources who increases NR_ACTIVE/INACTIVE?
I doubt one of your driver does increase and miss decrease.

>> Now kernel don't account kernel memory allocations except SLAB.
>
> I don't think that's entirely accurate.  I think cached, buffers,
> pagetables, vmallocUsed are all kernel allocations.  Granted, they're
> generally on behalf of userspace.

Yes. I just said simple. What I means kernel doesn't account whole memory
usage. :)

> I have a modified version of that which I picked up as part of the
> kmemleak backport.  However, it doesn't help unless I can narrow down
> *which* pages I should care about.

kmemleak doesn't support page allocator and ioremap.
Above URL patch just can tell who requests page which is using(ie, not
free) now.


> I tried using kmemleak directly, but it didn't find anything.  I've also
> tried checking for inactive pages which haven't been written to in 10
> minutes, and haven't had much luck there either.  But active/inactive
> keeps growing, and I don't know why.

If leak cause by alloc_page or __get_free_pages, kmemleak can't find leak.

>
> Chris
>



-- 
Kind regards,
Minchan Kim
