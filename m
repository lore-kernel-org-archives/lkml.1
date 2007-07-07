Return-Path: <linux-kernel-owner+w=401wt.eu-S1751257AbXGGFNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257AbXGGFNS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 01:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbXGGFMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 01:12:50 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34440 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbXGGFMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 01:12:49 -0400
Date: Fri, 6 Jul 2007 22:15:06 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.20.15
Message-ID: <20070707051506.GD20585@kroah.com>
References: <20070707051430.GC20585@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070707051430.GC20585@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 710c004..947ff3c 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 20
-EXTRAVERSION = .14
+EXTRAVERSION = .15
 NAME = Homicidal Dwarf Hamster
 
 # *DOCUMENTATION*
diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index f6fad71..6b7eaa0 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -518,7 +518,7 @@ int decode_seq(bitstr_t * bs, field_t * f, char *base, int level)
 			CHECK_BOUND(bs, 2);
 			len = get_len(bs);
 			CHECK_BOUND(bs, len);
-			if (!base) {
+			if (!base || !(son->attr & DECODE)) {
 				PRINT("%*.s%s\n", (level + 1) * TAB_SIZE,
 				      " ", son->name);
 				bs->cur += len;
@@ -704,6 +704,8 @@ int decode_choice(bitstr_t * bs, field_t * f, char *base, int level)
 	} else {
 		ext = 0;
 		type = get_bits(bs, f->sz);
+		if (type >= f->lb)
+			return H323_ERROR_RANGE;
 	}
 
 	/* Write Type */
