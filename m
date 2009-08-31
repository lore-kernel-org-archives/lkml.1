Return-Path: <linux-kernel-owner+w=401wt.eu-S1752377AbZHaMyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbZHaMyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 08:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbZHaMyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 08:54:08 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:38318 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbZHaMyH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 08:54:07 -0400
X-SpamScore: 2
X-BigFish: VPS2(zza594izz1202hzzz32i203h6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KP8RTX-01-9SO-02
X-M-MSG: 
Date: Mon, 31 Aug 2009 14:53:49 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <borislav.petkov@amd.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5 v6] x86: Adapt CPU topology detection for AMD
	Magny-Cours
Message-ID: <20090831125349.GA21867@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 31 Aug 2009 12:53:49.0303 (UTC) FILETIME=[15A42870:01CA2A3A]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Another version of patches to fix topology issues for AMD multi-node
processors. This time w/o introduction of new /sysfs attributes or
additional log messages.
It is just the pure stuff that is needed to fix some oddities
that occur when Linux is booted on Magny-Cours.

Please apply the patches. They should go into .32.

Users who are interested in which CPUs belong to the same internal
node have to check shared_cpu_map of L3 cache (i.e.
/sys/devices/system/cpu/cpuXY/cache/index3/shared_cpu_map or
/sys/devices/system/cpu/cpuXY/cache/index3/shared_cpu_list)

Boris might be interested in cpuinfo_x86->cpu_node_id. I use it to
store the entire NodeId  of AMD CPUs. That should be convenient
enough to find out the northbridge of a CPU in the EDAC driver.
 
The scheduler stuff is in flux in general and I don't expect that
scheduler gets fixed for Magny-Cours with .32. So be aware that
changing to power savings scheduling might bring down your multi-node
processor system.


Regards,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


