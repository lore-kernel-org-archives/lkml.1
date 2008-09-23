Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504AbYIWScQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbYIWScQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 14:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbYIWSb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 14:31:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:31061 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbYIWSb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 14:31:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=u0GDvSIVJJZwblaXsKrIS58ZR5TE1PVi+Wvt9JNJ0YQCtur4dJv4G9/Krz5VcBXqJQ
         3mQi/tjtoye81G1fJL9Yj7AhI1wNiMVVCFSTcCRFk3uagd4z+qNWO24qe5fN3xQVTtdg
         re6Yjsagf77yL7aR+IoC+yiysa87SMUQjyAV4=
Message-ID: <3baf3d760809231131g62748b73o7ba3e499f7cc6f4a@mail.gmail.com>
Date: Wed, 24 Sep 2008 00:01:57 +0530
From: "Singaravelan Nallasellan" <singaravelann@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Interrupt handler latency and Interrupt handling issues
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an issue in determining the source of the interrupt due to the
latency to access the register. The driver needs to send an read
request to another kernel driver. The other driver will use an
Indirect IO read to through an IO port. It will could also potentially
generate interrupt. It will lead to the latency issues in the
interrupt handler.

The driver may not be able to realiably identify the source of the
interrupt before coming out of the IRQ handler if it has to come out
the handler within a letency period.  Because of this, The driver will
not be able to say IRQ handled before coming out of the handler. If
the driver says IRQ handled assuming that the interrupt belongs to it,
it could also cause conflict with the other interrupt handler
registered for the same interrupt.

I am planning to say that IRQ handled in the Interrupt handler and
schedule a work queue to handle the identification and handling. Does
anybody see issues here? Are there any better mechanism to handle this
case?

Is there any latency requirements from the kernel?

How much is the tolerable latency for the interrupt handlers?

Thanks
