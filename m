Return-Path: <linux-kernel-owner+w=401wt.eu-S1757724AbYGVX12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724AbYGVX12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757186AbYGVXTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:19:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57835 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757178AbYGVXTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:19:47 -0400
Date: Tue, 22 Jul 2008 16:16:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Joonwoo Park <joonwpark81@gmail.com>, Patrick McHardy <kaber@trash.net>
Subject: [patch 27/47] textsearch: fix Boyer-Moore text search bug
Message-ID: <20080722231624.GB8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="textsearch-fix-boyer-moore-text-search-bug.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Joonwoo Park <joonwpark81@gmail.com>

Upstream commit aebb6a849cfe7d89bcacaaecc20a480dfc1180e7

The current logic has a bug which cannot find matching pattern, if the
pattern is matched from the first character of target string.
for example:
	pattern=abc, string=abcdefg
	pattern=a,   string=abcdefg
Searching algorithm should return 0 for those things.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
 lib/ts_bm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/ts_bm.c
+++ b/lib/ts_bm.c
@@ -63,7 +63,7 @@ static unsigned int bm_find(struct ts_co
 	struct ts_bm *bm = ts_config_priv(conf);
 	unsigned int i, text_len, consumed = state->offset;
 	const u8 *text;
-	int shift = bm->patlen, bs;
+	int shift = bm->patlen - 1, bs;
 
 	for (;;) {
 		text_len = conf->get_next_block(consumed, &text, conf, state);

-- 
