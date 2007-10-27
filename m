Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbXJ0MHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbXJ0MHz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 08:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbXJ0MHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 08:07:47 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:41885 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbXJ0MHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 08:07:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=QiBJorBnTDSnrkxXZJfEAOAf1zlkvVdJtFa2mekHxVq1DgpxANvhfT3R0I2CM/xiM+lJAm5yygdHz8OSq7SIg4rH4+viWLBzZhx/KD40jxDWLJObL/n7/saWfOxAwXPunK2fxmyOEuUWtYh0/PkednGq3DQvtaa3PbV0FeGaHxQ=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [BUG] [linux-pm] Commit "Hibernation: Enter platform hibernation state in a consistent way)" makes my system to resume instantly from S4
Date: Sat, 27 Oct 2007 14:05:32 +0200
User-Agent: KMail/1.9.6
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710271405.32908.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Recently I noticed that my system resumes just after suspend to disk.

I traced this to commit 9cd9a0058dd35268b24fa16795a92c800f4086d4.

Note:

This happens only if I enable WOL using /proc/acpi/wakeup
(echo "ILAN" > /proc/acpi/wakeup)

and have 
"ACPI-Hibernate-erroneously-disabled-Suspend-wakeup" applied, since otherwise
all wake-up sources are disabled in S4.


Clearly the above commit confuses the BIOS.
Using latest -git with the above patch reverted makes everything work again fine.

Best regards,
	Maxim Levitsky
