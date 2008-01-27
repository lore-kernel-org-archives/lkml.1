Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbYA0Okx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbYA0Okx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 09:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbYA0Okn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 09:40:43 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:52450 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbYA0Okm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 09:40:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=gAgnYeDe7ldI+5gxViRn5gQyw6swGjX/etsPUfkKFXKUYevMmd2xCPG7CHeKdGqgd5gXkM0WjRVRS/bg41KmCx89BMkhALeaz+7QurhPw+RjSdBPt2kMLmy7xcf/htZ6N7Bqyn/dODg5Ud5pKm9WHuvtyOGe9BIZ3sJ3rJLU3CY=
Message-ID: <3aa654a40801270640s59cfdcc4lfa3fb487e0d9b799@mail.gmail.com>
Date: Sun, 27 Jan 2008 06:40:40 -0800
From: "Avuton Olrich" <avuton@gmail.com>
To: "Zhao Yakui" <yakui.zhao@intel.com>
Subject: a7839e96 (PNP: increase max resources) breaks my ALSA intel8x0 sound card
Cc: "Li Shaohua" <shaohua.li@intel.com>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Thomas Renninger" <trenn@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux-Kernel," <linux-kernel@vger.kernel.org>,
       Alsa-Devel <alsa-devel@alsa-project.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With v2.6.24 my second ALSA sound device stopped working.

After bisection it says this was the offending commit.

a7839e960675b549f06209d18283d5cee2ce9261 is first bad commit
commit a7839e960675b549f06209d18283d5cee2ce9261
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Wed Nov 28 16:21:21 2007 -0800

    PNP: increase the maximum number of resources

    On some systems the number of resources(IO,MEM) returnedy by PNP device is
    greater than the PNP constant, for example motherboard devices.  It brings
    that some resources can't be reserved and resource confilicts.  This will
    cause PCI resources are assigned wrongly in some systems, and cause hang.
    This is a regression since we deleted ACPI motherboard driver and use PNP
    system driver.

    [akpm@linux-foundation.org: fix text and coding-style a bit]
    Signed-off-by: Li Shaohua <shaohua.li@intel.com>
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
    Cc: Thomas Renninger <trenn@suse.de>
    Cc: <stable@kernel.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

The audio device is 00:1b.0 (see my lspci -vvv output), the other
audio device works fine.

http://avuton.googlepages.com/v2.6-before (dmesg revision before)
http://avuton.googlepages.com/v2.6-after (dmesg broken revision)
http://avuton.googlepages.com/lspci-vvv
http://avuton.googlepages.com/config (from the broken revision)
http://avuton.googlepages.com/iomem
http://avuton.googlepages.com/ioports
-- 
avuton
--
 Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
