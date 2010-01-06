Return-Path: <linux-kernel-owner+w=401wt.eu-S1755100Ab0AFP1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab0AFP1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 10:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624Ab0AFP1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 10:27:41 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:42254 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab0AFP1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 10:27:39 -0500
Date: Wed, 6 Jan 2010 15:27:24 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>
Subject: Re: Regression in module wmi since 2.6.32 (bisected to commit
	1caab3c)
Message-ID: <20100106152724.GA15664@srcf.ucam.org>
References: <4B352513.90302@lwfinger.net> <200912252056.08436.carlos@strangeworlds.co.uk> <4B353035.4050208@lwfinger.net> <200912252158.31127.carlos@strangeworlds.co.uk> <4B353818.1020308@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B353818.1020308@lwfinger.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hm. I think this is an artifact of the way we're treating WMI right now. 
The assumption is that the interfaces are defined in namespace by their 
GUID, whereas in fact they're defined by their ACPI namespace. Can we 
avoid this by just setting the parent to the ACPI device's corresponding 
Linux device (if present) and including the WMI device's name in the 
dev_set_name call?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
