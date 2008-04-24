Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbYDXCDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbYDXCDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 22:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYDXCDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 22:03:14 -0400
Received: from rv-out-0708.google.com ([209.85.198.249]:3605 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751711AbYDXCDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 22:03:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ff9/lp3jAtFs0Z/QTLa390m2T5mlb/rTmEwSWkvdwC6TvhQACSv+A+aqxClQhIDMjTCmhJxgIi5iA1u6ekbxr8cVCfMXGWp6SPlXSqoBFgsL1PJP2dCrwVBWkmiCk4b2iayy19e1RZK9B4ZQlMpk/OUCBq84ErP7U72GC2Wx8NM=
Message-ID: <44c63dc40804231903m654736e7k47d79373d5449571@mail.gmail.com>
Date: Thu, 24 Apr 2008 11:03:11 +0900
From: "minchan Kim" <barrioskmc@gmail.com>
To: linux-kernel@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: wrong comment in do_try_to_free_pages ?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

static unsigned long do_try_to_free_pages(struct zone **zones, gfp_t gfp_mask,
           struct scan_control *sc)
...
...
   /* Take a nap, wait for some writeback to complete */
   if (sc->nr_scanned && priority < DEF_PRIORITY - 2)
     congestion_wait(WRITE, HZ/10);
 }
 /* top priority shrink_caches still had more to do? don't OOM, then */
                     ^^^^^^^^^^^^^^^^^
 if (!sc->all_unreclaimable && scan_global_lru(sc))
   ret = 1;
out:
 /*
....

I think we change shrink_caches commet with shrink_zone.

And I can't understand that's comment.

What's role sc->all_unreclaimable ?
What benefit do we can get with that code ?
If we don't have that code, What's problem happen ?

-- 
Thanks,
barrios
