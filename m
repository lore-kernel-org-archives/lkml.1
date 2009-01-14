Return-Path: <linux-kernel-owner+w=401wt.eu-S1760712AbZANWCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760712AbZANWCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 17:02:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846AbZANWCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 17:02:06 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58349 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbZANWCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 17:02:04 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 14 Jan 2009 23:01:44 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: linux-next: Tree for January 14 (multimedia/firesat-rc)
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <496E1F84.7040605@oracle.com>
Message-ID: <tkrat.777f93296cb7b932@s5r6.in-berlin.de>
References: <20090114165002.3bbe49d7.sfr@canb.auug.org.au>
 <496E1F84.7040605@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> drivers/built-in.o: In function `input_report_key':
> firesat-rc.c:(.text+0x776f3): undefined reference to `input_event'
> drivers/built-in.o: In function `firesat_register_rc':
> (.text+0x777af): undefined reference to `input_allocate_device'
> drivers/built-in.o: In function `firesat_register_rc':
> (.text+0x7781c): undefined reference to `input_register_device'
> drivers/built-in.o: In function `firesat_register_rc':
> (.text+0x77834): undefined reference to `input_free_device'
> drivers/built-in.o: In function `firesat_unregister_rc':
> (.text+0x7779d): undefined reference to `input_unregister_device'
> 
> config attached.
...
> # Input device support
> #
> # CONFIG_INPUT is not set

Thanks.  firesat a.k.a. firedtv lives currently in linux1394-2.6.git.


From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: firedtv: add missing dependency on CONFIG_INPUT

Fix build error \
Reported-by: Randy Dunlap <randy.dunlap@oracle.com>

Perhaps we should make the remote control part of firedtv modular so
that the driver can be built without input support.  But it's not very
likely that anybody would have use for such a constellation.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

I need to fold it into "DVB: add firesat driver" before I submit the
driver for mainline merge.

 drivers/media/dvb/firesat/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/media/dvb/firesat/Kconfig
===================================================================
--- linux.orig/drivers/media/dvb/firesat/Kconfig
+++ linux/drivers/media/dvb/firesat/Kconfig
@@ -1,6 +1,6 @@
 config DVB_FIREDTV
 	tristate "FireDTV (FireWire attached DVB receivers)"
-	depends on DVB_CORE && IEEE1394
+	depends on DVB_CORE && IEEE1394 && INPUT
 	help
 	  Support for DVB receivers from Digital Everywhere, known as FireDTV
 	  and FloppyDTV, which are connected via IEEE 1394 (FireWire).


-- 
Stefan Richter
-=====-==--= ---= -===-
http://arcgraph.de/sr/

