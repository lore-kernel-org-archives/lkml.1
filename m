Return-Path: <linux-kernel-owner+w=401wt.eu-S934637AbZIEAVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934637AbZIEAVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964833AbZIEAVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:21:37 -0400
Received: from kroah.org ([198.145.64.141]:42209 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934628AbZIEAVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:21:04 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:53 2009
Message-Id: <20090905001453.218323397@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:14:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kashyap Desai <kashyap.desai@lsi.com>,
       James Bottomley <James.Bottomley@suse.de>
Subject: [patch 38/71] SCSI: mpt2sas: Introduced check for enclosure_handle to avoid crash
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=scsi-mpt2sas-introduced-check-for-enclosure_handle-to-avoid-crash.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Kashyap, Desai <kashyap.desai@lsi.com>

commit 15052c9e85bf0cdadcb69eb89623bf12bad8b4f8 upstream.

Kernel panic is seen because of enclosure_handle received from FW is zero.
Check is introduced before calling mpt2sas_config_get_enclosure_pg0.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3442,12 +3442,11 @@ _scsih_add_device(struct MPT2SAS_ADAPTER
 	sas_device->hidden_raid_component = is_pd;
 
 	/* get enclosure_logical_id */
-	if (!(mpt2sas_config_get_enclosure_pg0(ioc, &mpi_reply, &enclosure_pg0,
-	   MPI2_SAS_ENCLOS_PGAD_FORM_HANDLE,
-	   sas_device->enclosure_handle))) {
+	if (sas_device->enclosure_handle && !(mpt2sas_config_get_enclosure_pg0(
+	   ioc, &mpi_reply, &enclosure_pg0, MPI2_SAS_ENCLOS_PGAD_FORM_HANDLE,
+	   sas_device->enclosure_handle)))
 		sas_device->enclosure_logical_id =
 		    le64_to_cpu(enclosure_pg0.EnclosureLogicalID);
-	}
 
 	/* get device name */
 	sas_device->device_name = le64_to_cpu(sas_device_pg0.DeviceName);


