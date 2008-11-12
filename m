Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbYKLAgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbYKLAgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbYKLA0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:38 -0500
Received: from kroah.org ([198.145.64.141]:42418 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753626AbYKLA0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:36 -0500
Date: Tue, 11 Nov 2008 16:23:49 -0800
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
       alan@lxorguk.ukuu.org.uk, Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Dan Williams <dan.j.williams@intel.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 27/49] dca: fixup initialization dependency
Message-ID: <20081112002349.GB10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dca-fixup-initialization-dependency.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 1207e795568a368928dfd23d6817e47f2e8097e3 upstream

Mark dca_init as a subsys_initcall since it needs to be ready to go
before dependent drivers start registering themselves.

Reported-and-tested-by: Mark Rustad <mark_rustad@Xiotech.com>
Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/dca/dca-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dca/dca-core.c
+++ b/drivers/dca/dca-core.c
@@ -270,6 +270,6 @@ static void __exit dca_exit(void)
 	dca_sysfs_exit();
 }
 
-module_init(dca_init);
+subsys_initcall(dca_init);
 module_exit(dca_exit);
 

-- 
