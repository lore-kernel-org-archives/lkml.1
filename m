Return-Path: <linux-kernel-owner+w=401wt.eu-S1756486AbZKMRVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbZKMRVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 12:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756191AbZKMRVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 12:21:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:48852 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887AbZKMRVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 12:21:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=gEvyvMrDKGAu58xj2/xhXPoofjMKzGNwqs2tMXRg/fK2jeWfnSdVMT2/1dsyTtk3Lq
         FGa2KFAKAu2qUTrkx/OXutc8YoiybdB35IkpkTbE8dlO/nRSckvZbzufaGJF6lxgkMYR
         VEwyIDtO4olnHePGe+bolKDCYANvxufr3c7/c=
Message-ID: <4AFD958E.1000303@lwfinger.net>
Date: Fri, 13 Nov 2009 11:21:18 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Linux ACPI <linux-acpi@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       bcm43xx devel <Bcm43xx-dev@lists.berlios.de>,
       Michael Buesch <mb@bu3sch.de>,
       =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: 64-bit DMA problems with BCM4312 using b43
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A number of users are experiencing DMA descriptor or data errors using 64-bit
DMA with the Broadcom BCM4312 wireless device. After careful review and a
rewrite of the DMA code in the driver, we have not been able to fix the problem,
but we have determined the following:

(1) The problem is much more likely to occur on netbook systems. Several of the
developers have this card in regular notebook systems. None of us have the
problem. Several brand/model combinations are affected including Dell Inspiron
910 and Acer Aspire One A150. Linus has also reported the same symptoms with a
Core 2 ULV CPU. One of our devs questions if the deep-sleep support in the CPU
is a problem. It is also believed that affected systems have a Phoenix BIOS.

(2) If CONFIG_ACPI_PROCESSOR is not set on affected systems, the error rate is
much lower.

(3) When a DMA descriptor error occurs, a dump of the descriptors does not
reveal any obvious problems.

(4) Once the problem occurs, resetting of the device does not restore proper
operations. It is not a transient error.

Support for this device was not enabled in mainline until 2.6.32-rc2.

I do not know enough about either the ACPI or DMA code to begin debugging in
either of those regions. Any suggestions on debugging strategies, or links to
similar problems would be appreciated.

Thanks,

Larry

