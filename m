Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbZB1DFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbZB1DFs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 22:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbZB1DFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 22:05:40 -0500
Received: from web33001.mail.mud.yahoo.com ([209.191.69.116]:39292 "HELO
	web33001.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752090AbZB1DFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 22:05:40 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Feb 2009 22:05:39 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type;
  b=AMisM58e+AkUzNr7p7qOTqitIc/kZzMUD/BdrgyXBJbEc48vH8tFA4OUAJ+oLfRpYSYdxniz2kiV6/3o2qJCp+RN04+39kV6nJl4w0+OZtj2+QSDaH2rVpoRuJ1FM+khuBT1ayYVR8oljcbdotoiVkn43HEe0u6raW9ZSJ2JzsY=;
Message-ID: <968150.85968.qm@web33001.mail.mud.yahoo.com>
X-YMail-OSG: Np3of7wVM1kc39PMs6kypCA0v2UROCyCJDlVmDJ8vc1ANGLec9AHhcQHtJmxkOO1B2Ax_OJ4MfZGbEBdG.YXgye_mw1bYK1cxDUl9e3IAfEfFLnew4O4VYBwSV1m6KfmqDpDQnUbrlQRhTPWT22FYqGOMeF16JgID6QWvdaC_g8V1w--
X-Mailer: YahooMailWebService/0.7.289.1
Date: Fri, 27 Feb 2009 18:58:57 -0800 (PST)
From: Stephen Cameron <smcameron@yahoo.com>
Reply-To: smcameron@yahoo.com
Subject: Re: hpsa: SCSI driver for HP Smart Array controllers
To: linux-kernel@vger.kernel.org
Cc: scameron@beardog.cca.cpqcorp.net, mike.miller@hp.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



I see we botched this in hpsa_pci_init()
(one of the last things we changed):

+       if (prod_index == ARRAY_SIZE(products)) {
+               prod_index--;
+               if (subsystem_vendor_id == !PCI_VENDOR_ID_HP ||
+                               !allow_unknown_smartarray) {
+                       printk(KERN_WARNING "hpsa: Sorry, I don't "
+                               "know how to access the Smart "
+                               "Array controller %08lx\n",


That 2nd if should have been, 

if (subsystem_vendor_id != PCI_VENDOR_ID_HP ||

-- steve


      
