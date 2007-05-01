Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbXEAPIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbXEAPIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 11:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbXEAPID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 11:08:03 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:58983 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754674AbXEAPIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 11:08:00 -0400
Subject: [PATCH 0/5] Add LZO Compression
From: Richard Purdie <rpurdie@openedhand.com>
To: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
       herbert@gondor.apana.org.au
Cc: linux-mtd <linux-mtd@lists.infradead.org>, linux-crypto@vger.kernel.org
Content-Type: text/plain
Date: Tue, 01 May 2007 15:46:34 +0100
Message-Id: <1178030794.5883.50.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series adds LZO compression support to the kernel
and exposes it in a variety of places (jffs2, crypto).

Its a resend of a previous posted series, rediffed against recent
kernels with the couple of minors issues raised by David Woodhouse
addressed.

This patch series is also available as:
git://git.o-hand.com/linux-rpurdie linux-rpurdie-lzo
(http://git.o-hand.com/?p=linux-rpurdie;a=shortlog;h=linux-rpurdie-lzo)

LZO compression is particularly useful for jffs2 where significant boot
time speedups (~10%) and file read speed improvements (~40%) are seen
when its used with only a slight drop in file compression ratio.

It also adds a favourlzo mode to jffs2 which is similar to the existing
size mode but lets lzo compression win if the lzo compressed size is
"similar" to but not the best compression ratio. This means we can keep
zlib compression where it makes a significant difference to compressed
file size.

The final jffs2 patch which starts adding sysfs support for control of
jffs2 options at runtime that are currently available only at boottime.
There are several other controls which it may be desirable to add to the
basic framework this patch creates in due course.

Richard


