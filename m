Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbZGTNih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbZGTNih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 09:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbZGTNif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 09:38:35 -0400
Received: from ns2.gothnet.se ([82.193.160.251]:12236 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753921AbZGTNif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 09:38:35 -0400
Message-ID: <4A647358.1040009@shipmail.org>
Date: Mon, 20 Jul 2009 15:38:32 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>
Organization: VMware
User-Agent: Thunderbird 1.5.0.7 (X11/20060921)
MIME-Version: 1.0
To: DRI <dri-devel@lists.sourceforge.net>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: DRM drivers with closed source user-space: WAS  [Patch 0/3] Resubmit
 VIA Chrome9 DRM via_chrome9 for upstream
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-BitDefender-Scanner: Mail not scanned due to license constraints
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

It appears that GPL'd DRM drivers for closed-source user-space clients 
are becoming more common, and the situation appears to be causing a lot 
of unnecessary work from people wanting their drivers in the mainstream 
kernel. Arguments against pushing upstream include.

    * Security.
    * User space interface validation and maintainability.
    * Politics


Security:
I think from a security point of view, open docs and a thorough 
documented security analysis by the driver writer should be sufficient. 
This should include:

   1. In what ways can the GPU access random system pages and how is
      user-space prevented from doing that in the driver?
   2. In what ways can the GPU transfer random user data into its own
      privileged command stream and, if relevant, how is that prevented
      in the driver?
   3. Is the driver capable of maintaining video memory ownership and
      protecition?
      (Currently not a requirement)
   4. How is user-space prevented from causing the kernel driver to do
      unlimited allocations of kernel resources, like buffer objects or
      references to them.

I really don't think an open-source user-space client can add much more 
to this. It can perhaps be used to detect obvious big security flaws but 
that should be apparent also from the open docs and the security analysis.

User-space interface:
Historically driver-specific interfaces have really been up to the 
driver writer and when posted for review they receive very little 
comments unless there are things like 64/32 bit incompatibilities etc, 
but as mentioned on the list, small programs that demonstrate the use of 
all interface functions would be desirable, and very helpful if someone 
decides to do write an open-source driver.

Politics:
It's true that sometimes some people don't like the code or what it 
does. But when this is the underlying cause of NAK-ing a driver I think 
it's very important that this is clearly stated, instead of inventing 
various random reasons that can easily be argued against. How should the 
driver writer otherwise get it right? Man-years might be spent fixing up 
drivers that will never get upstream anyway.

I think it would help a lot of there was a documented set of driver 
features that were required and sufficient for a DRM driver to go 
upstream. It could look something like

    * Kernel coding style obeyed. Passing checkpatch.
    * short description of underlying driver architecture (GEM / TTM /
      Traditional) and future plans
    * Security analysis according to the above.
    * Open user-space source exercising all functions of the driver or
      fully open docs.
    * User-space interface description and relation to future plans.


Thanks,
/Thomas








