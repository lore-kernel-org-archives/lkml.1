Return-Path: <linux-kernel-owner+w=401wt.eu-S1757624AbYFPVQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbYFPVQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 17:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496AbYFPVQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 17:16:47 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:41492 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470AbYFPVQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 17:16:46 -0400
Date: Mon, 16 Jun 2008 23:16:36 +0200
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: linux-kernel@vger.kernel.org
Cc: nikola.ciprich@linuxbox.cz, e1000-devel@lists.sourceforge.net
Subject: [regression?] e1000e breaks IPMI
Message-ID: <20080616211636.GA5179@develbox.linuxbox.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Antivirus: on proxybox by Kaspersky antivirus, engine 5.5.10, data 778210 records(16-06-2008)
X-Envelope-From: ciprich@linuxbox.cz
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
it seems that e1000e breaks IPMI support on at least some motherboards (ie SuperMicro PDSMi-LN4 with AOC-IPMI20-E+ module, and also others).
When e1000e module is loaded, IPMI module stops to respond. The problem is, that it was working before, so I tried examining further and bisect showed that following commit caused it to stop working:

commit 5918bd88effd0233a048983570ec5803f5f753dc
Author: Auke Kok <auke-jan.h.kok@intel.com>
Date:   Tue Feb 12 15:20:24 2008 -0800

    e1000e: Fix CRC stripping in hardware context bug

    CRC stripping was only correctly enabled for packet split recieves
    which is used when receiving jumbo frames. Correctly enable SECRC
    also for normal buffer packet receives.

    Tested by Andy Gospodarek and Johan Andersson, see bugzilla #9940.

    Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

I can confirm that reverting the patch makes IPMI work again. So it either is a regression, or maybe just trigger for some other bug (seems more likely to me). Pity I haven't noticed it sooner, we've been using older e1000[e] drivers up to now.

Any suggestions on where the problem could be?

cheers

nik

-- 
-------------------------------------
Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
