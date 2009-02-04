Return-Path: <linux-kernel-owner+w=401wt.eu-S1763499AbZBDTDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763499AbZBDTDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:03:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759481AbZBDStl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:49:41 -0500
Received: from kroah.org ([198.145.64.141]:32906 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761401AbZBDStb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:49:31 -0500
Date: Wed, 4 Feb 2009 10:46:50 -0800
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
       alan@lxorguk.ukuu.org.uk, Bob Moore <robert.moore@intel.com>,
       Lin Ming <ming.m.lin@intel.com>, Andi Kleen <ak@linux.intel.com>,
       Len Brown <len.brown@intel.com>, Thomas Renninger <trenn@suse.de>
Subject: [patch 31/41] ACPICA: Fix wrong resource descriptor length for
	64-bit build
Message-ID: <20090204184650.GF25246@kroah.com>
References: <20090204184029.881610776@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpica-fix-wrong-resource-descriptor-length-for-64-bit-build.patch"
In-Reply-To: <20090204184539.GA25246@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bob Moore <robert.moore@intel.com>

commit 9db4fcd99f7ef886ded97cd26a8642c70fbe34df upstream.

The "minimal" descriptors such as EndTag are calculated as 12
bytes long, but the actual length in the internal descriptor is
16 because of the round-up to 8 on 64-bit build.

http://www.acpica.org/bugzilla/show_bug.cgi?id=728

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/acpi/actypes.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -1225,8 +1225,8 @@ struct acpi_resource {
 
 #pragma pack()
 
-#define ACPI_RS_SIZE_MIN                    12
 #define ACPI_RS_SIZE_NO_DATA                8	/* Id + Length fields */
+#define ACPI_RS_SIZE_MIN                    (u32) ACPI_ROUND_UP_TO_NATIVE_WORD (12)
 #define ACPI_RS_SIZE(type)                  (u32) (ACPI_RS_SIZE_NO_DATA + sizeof (type))
 
 #define ACPI_NEXT_RESOURCE(res)             (struct acpi_resource *)((u8 *) res + res->length)

