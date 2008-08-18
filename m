Return-Path: <linux-kernel-owner+w=401wt.eu-S1762801AbYHRTFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762801AbYHRTFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932509AbYHRTDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:03:03 -0400
Received: from mx1.suse.de ([195.135.220.2]:43978 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932507AbYHRTDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:03:00 -0400
Date: Mon, 18 Aug 2008 11:45:12 -0700
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
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, TAKADA Yoshihito <takada@mbf.nifty.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 45/60] cs5520: add enablebits checking
Message-ID: <20080818184512.GT29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cs5520-add-enablebits-checking.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

upstream commit is 24307ffabd5b39bad443641f54b12ee2ba7a38ac

Based on sparse comments in OpenFirmware code
(no Cx5510/Cx5520 datasheet here).

This fixes 2.6.26 regression reported by TAKADA
and caused by addition of warm-plug support.

Tested-by: TAKADA Yoshihito <takada@mbf.nifty.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/pci/cs5520.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -123,6 +123,7 @@ static const struct ide_dma_ops cs5520_d
 #define DECLARE_CS_DEV(name_str)				\
 	{							\
 		.name		= name_str,			\
+		.enablebits	= { {0x60, 0x01, 0x01}, {0x60, 0x02, 0x02} }, \
 		.port_ops	= &cs5520_port_ops,		\
 		.dma_ops	= &cs5520_dma_ops,		\
 		.host_flags	= IDE_HFLAG_ISA_PORTS |		\

-- 
