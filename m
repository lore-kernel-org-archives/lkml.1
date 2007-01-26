Return-Path: <linux-kernel-owner+w=401wt.eu-S1161198AbXAZTUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161198AbXAZTUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 14:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161203AbXAZTUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 14:20:53 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:6093 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161198AbXAZTUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 14:20:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=S45psG/ABfUkQLAWL949Iw8652tskTBPnth7puP9fUetdwdOcjiTn/X+727GLJoCcp6tBKUW+VI6wuJ01R5YidybgT3mtiziu/ISBa5WtmJjRCEdsxENhIAFZdtiHhZG79spU5pWvOc3lwII6qh4Td6tH/EpVOVyGv+8SJOl7Dg=
Message-ID: <45BA5484.9020802@googlemail.com>
Date: Fri, 26 Jan 2007 20:20:36 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>  <45BA42B9.7020203@googlemail.com>  <6bffcb0e0701261008u2fd5a7d9va16d7fd9f250e14b@mail.gmail.com>  <Pine.LNX.4.64.0701261035430.7848@schroedinger.engr.sgi.com> <6bffcb0e0701261045q29cdb4ceq4577e5b0cec55d66@mail.gmail.com> <Pine.LNX.4.64.0701261103530.5622@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0701261103530.5622@schroedinger.engr.sgi.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter napisał(a):
> On Fri, 26 Jan 2007, Michal Piotrowski wrote:
> 
>> Please try patches from
>> http://www.stardust.webpages.pl/files/tbf/euridica/mm-snapshot-2007-01-26/
>>
>> http://www.stardust.webpages.pl/files/tbf/euridica/mm-snapshot-2007-01-26/bugs_and_patches.txt
> 
> Ahh. Okay that fixes most of the issues
> 
> 
> ZVC writeback: Fix mm and other issues
> 
> This deals with swap prefetch and various things changed in mm.
> 

Additional fix

Regards,
Michal

--
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-work-clean/kernel/power/snapshot.c	2007-01-26 16:45:32.000000000 +0100
+++ linux-work/kernel/power/snapshot.c	2007-01-26 20:17:09.000000000 +0100
@@ -591,7 +591,7 @@ static unsigned int count_free_highmem_p

 	for_each_zone(zone)
 		if (populated_zone(zone) && is_highmem(zone))
-			cnt += zone->free_pages;
+			cnt += zone_page_state(zone, NR_FREE_PAGES);

 	return cnt;
 }
@@ -869,7 +869,7 @@ static int enough_free_mem(unsigned int
 	for_each_zone(zone) {
 		meta += snapshot_additional_pages(zone);
 		if (!is_highmem(zone))
-			free += zone->free_pages;
+			free += zone_page_state(zone, NR_FREE_PAGES);
 	}

 	nr_pages += count_pages_for_highmem(nr_highmem);

