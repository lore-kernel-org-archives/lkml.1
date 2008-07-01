Return-Path: <linux-kernel-owner+w=401wt.eu-S1759546AbYGAOsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546AbYGAOsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 10:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756216AbYGAOsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 10:48:10 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:20255 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbYGAOsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 10:48:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=JwY6zEZZmVEyW8y8Z+H1KVik+vbzrqb9w0DLQ52fN/KeckPSQGeuV1qeNJmuW6N7Cy
         2JieKrQRoIBIkQ0pF0zXnwQuKa1MMBJAD2uPOEQjNcG445z/BimLhEXCTr2eWI/SreXT
         HwqDD4lmxH3DmTUGjggxehuobCaO0ln9aWIl4=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Hannes Reinecke <hare@suse.de>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: [PATCH 0/3] aic7xxx: debloat
Date: Tue, 1 Jul 2008 18:48:22 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807011848.22599.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hannes,

aic7xxx still contains ~30kb of dead code if pretty printing of registers
is requested. These patches deal with it.

I did not get any feedback from you whether the approach of adding
"dont_generate_debug_code" marker would be acceptable despite
asking twice. I decided that it's a "Yes".

The patches are compile tested on linux-2.6.26-rc8 and apply cleanly to
current scsi-misc.

Size differences:

   text    data     bss     dec     hex filename
DEBUG_ENABLE+PRETTY_PRINT:
 234697    2362    1188  238247   3a2a7 linux-2.6.26-rc8-/drivers/scsi/aic7xxx/built-in.o
 205092    2362    1188  208642   32f02 linux-2.6.26-rc8/drivers/scsi/aic7xxx/built-in.o
NO_DEBUG_ENABLE+PRETTY_PRINT:
 227272    2362    1172  230806   38596 linux-2.6.26-rc8-/drivers/scsi/aic7xxx/built-in.o
 197671    2362    1172  201205   311f5 linux-2.6.26-rc8/drivers/scsi/aic7xxx/built-in.o
DEBUG_ENABLE+NO_PRETTY_PRINT:
 192457    2362    1188  196007   2fda7 linux-2.6.26-rc8-/drivers/scsi/aic7xxx/built-in.o
 192457    2362    1188  196007   2fda7 linux-2.6.26-rc8/drivers/scsi/aic7xxx/built-in.o
NO_DEBUG_ENABLE+NO_PRETTY_PRINT:
 185040    2362    1172  188574   2e09e linux-2.6.26-rc8-/drivers/scsi/aic7xxx/built-in.o
 185040    2362    1172  188574   2e09e linux-2.6.26-rc8/drivers/scsi/aic7xxx/built-in.o

Please apply to scsi-misc.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda
