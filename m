Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268Ab0AZXsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab0AZXsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150Ab0AZXsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:48:06 -0500
Received: from kroah.org ([198.145.64.141]:35491 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754916Ab0AZXoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:44:14 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:31 2010
Message-Id: <20100126233931.624064978@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Horton <zero@colonel-panic.org>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [82/98] UBI: initialise update marker
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Horton <zero@colonel-panic.org>

commit ff998793288b49a3b22d929bf8e56362320905ff upstream.

The in kernel copy of a volume's update marker is not initialised from the
volume table. This means that volumes where an update was unfinnished will
not be treated as "forbidden to use". This is basically that the update
functionality was broken.

Signed-off-by: Peter Horton <zero@colonel-panic.org>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mtd/ubi/vtbl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mtd/ubi/vtbl.c
+++ b/drivers/mtd/ubi/vtbl.c
@@ -566,6 +566,7 @@ static int init_volumes(struct ubi_devic
 		vol->reserved_pebs = be32_to_cpu(vtbl[i].reserved_pebs);
 		vol->alignment = be32_to_cpu(vtbl[i].alignment);
 		vol->data_pad = be32_to_cpu(vtbl[i].data_pad);
+		vol->upd_marker = vtbl[i].upd_marker;
 		vol->vol_type = vtbl[i].vol_type == UBI_VID_DYNAMIC ?
 					UBI_DYNAMIC_VOLUME : UBI_STATIC_VOLUME;
 		vol->name_len = be16_to_cpu(vtbl[i].name_len);


