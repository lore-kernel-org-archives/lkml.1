Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbZC0ALD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbZC0ALD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 20:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932774AbZC0AKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 20:10:17 -0400
Received: from brm-mailgate-2.brocade.com ([144.49.197.3]:10633 "EHLO
	brm-mailgate-2.brocade.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932818AbZC0AKP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 20:10:15 -0400
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Mar 2009 20:10:15 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: bug in drivers/edac/edac_core.h pci_write_bits32()
Date: Thu, 26 Mar 2009 16:54:01 -0700
Message-ID: <57AC2FA1761300418C7AB8F3EA493C9702B52DC8@HQ-EXCH-5.corp.brocade.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: bug in drivers/edac/edac_core.h pci_write_bits32()
Thread-Index: AcmubiMvWjCW/XJcRlilLqFaX1agJw==
From: "Jeff Haran" <jharan@Brocade.COM>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 26 Mar 2009 23:55:01.0077 (UTC) FILETIME=[4697F850:01C9AE6E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29 and previous versions seem to contain this bug which I found just
eyeballing the code:

static inline void pci_write_bits32(struct pci_dev *pdev, int offset,
                    u32 value, u32 mask)
{
    if (mask != 0xffff) {
        u32 buf;

        pci_read_config_dword(pdev, offset, &buf);
        value &= mask;
        buf &= ~mask;
        value |= buf;
    }

    pci_write_config_dword(pdev, offset, value);
}

I'm pretty sure that "if" statement should be:

	if (mask != 0xffffffff) {

Please copy my email address in any response as I do not subscribe.

Thanks,

Jeff Haran
Brocade
