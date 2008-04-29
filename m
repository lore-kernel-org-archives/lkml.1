Return-Path: <linux-kernel-owner+w=401wt.eu-S1760953AbYD2RYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760953AbYD2RYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758123AbYD2RUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:20:43 -0400
Received: from ns2.suse.de ([195.135.220.15]:43032 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758101AbYD2RUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:20:42 -0400
Date: Tue, 29 Apr 2008 10:18:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <mbroz@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [12/37] dm snapshot: fix chunksize sector conversion
Message-ID: <20080429171823.GM14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dm-snapshot-fix-chunksize-sector-conversion.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Mikulas Patocka <mpatocka@redhat.com>

commit: 924362629bf5645aee5f49f8a0d0d5b193e65997

If a snapshot has a smaller chunksize than the page size the
conversion to pages currently returns 0 instead of 1, causing:
kernel BUG in mempool_resize.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-exception-store.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -131,7 +131,7 @@ struct pstore {
 
 static unsigned sectors_to_pages(unsigned sectors)
 {
-	return sectors / (PAGE_SIZE >> 9);
+	return DIV_ROUND_UP(sectors, PAGE_SIZE >> 9);
 }
 
 static int alloc_area(struct pstore *ps)

-- 
