Return-Path: <linux-kernel-owner+w=401wt.eu-S965883AbXEUUCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965883AbXEUUCB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 16:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935380AbXEUUBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 16:01:04 -0400
Received: from pat.uio.no ([129.240.10.15]:55042 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935223AbXEUUBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 16:01:00 -0400
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <CEAADB30-FB4E-4F2B-BBF9-DD085FBF9B55@usit.uio.no>
Cc: linux-scsi@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Hans A Eide <h.a.eide@usit.uio.no>
Subject: Re: [PATCH] sata_promise: Port enumeration order - SATA 150 TX4,
Date: Mon, 21 May 2007 22:00:43 +0200
To: linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.752.3)
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, AWL=0.032)
X-UiO-Scanned: 1C295B5AF5916E94C64C199EF530C3E39142243C
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 29 total 1858319 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


 > Evan Harris wrote:
 >>
 >> I have a card that mirrors this one from your list:
 >>
 >> Retail name: SATA300 TX4
 >> Chip label: PDC40718-GP  SATAII300
 >> Vendor-Device number: 105a:3d17 (rev 02)
 >>
 >> Through testing, I've found linux 2.6.16 and 2.6.17 find the  
ports in
 >> this order (the list is ordered by linux detection):
 >>
 >> 1. silkscreen port 3
 >> 2. silkscreen port 2
 >> 3. silkscreen port 4
 >> 4. silkscreen port 1
 >>> NOTE: the patch I have submitted (
 >>> http://marc.theaimsgroup.com/?l=linux- 
ide&m=114082978311290&w=2 ) is a
 >>> solution that doesn't know about the older Promise SATA  
controllers,
 >>> which are not affected with the "new wiring" problem, so the older
 >>> controllers will appear screwed if you use it.
 >>>
 >>> Hopefully we will collect enough info about all the SATA Promise
 >>> controllers to distinguish the new and the old wiring controllers,
 >>> then produce a new patch that will be a correct solution to the  
"new
 >>> wiring" problem.
 >
 > Mikael Pettersson has been doing some excellent work recently on
 > sata_promise.  If enough data has been collected on this sata_promise
 > port enumeration problem, maybe the data could be collated and  
proposed
 > via Mikael as a patch?
 >
 > 	Jeff

Sorry, any updates on this?

An updated patch for "new wiring" would be

--- sata_promise.c      2007-05-20 21:35:54.000000000 +0200
+++ sata_promise.c.new_enum     2007-05-21 21:52:38.000000000 +0200
@@ -915,9 +915,11 @@
                 hp->flags |= PDC_FLAG_GEN_II;
                 /* Fall through */
         case board_20319:
-                       probe_ent->n_ports = 4;
-               pdc_ata_setup_port(&probe_ent->port[2], base + 0x300,  
base + 0x600);
-               pdc_ata_setup_port(&probe_ent->port[3], base + 0x380,  
base + 0x700);
+               probe_ent->n_ports = 4;
+               pdc_ata_setup_port(&probe_ent->port[0], base + 0x380,  
base + 0x400);
+               pdc_ata_setup_port(&probe_ent->port[1], base + 0x280,  
base + 0x500);
+               pdc_ata_setup_port(&probe_ent->port[2], base + 0x200,  
base + 0x600);
+               pdc_ata_setup_port(&probe_ent->port[3], base + 0x300,  
base + 0x700);
                 break;
         case board_2057x:
                 hp->flags |= PDC_FLAG_GEN_II;


Correct?


Hans


