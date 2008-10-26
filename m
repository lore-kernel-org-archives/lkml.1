Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbYJ0AGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbYJ0AGF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 20:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbYJ0AFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 20:05:54 -0400
Received: from sec.bit-consulting.com.ar ([200.69.255.76]:60972 "EHLO
	sec.bit-consulting.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbYJ0AFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 20:05:53 -0400
X-Greylist: delayed 1164 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Oct 2008 20:05:53 EDT
From: "Diego M. Vadell" <dvadell@linuxclusters.com.ar>
Organization: Linuxclusters
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: PAT and MTRRs
Date: Sun, 26 Oct 2008 22:46:21 -0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810262246.21807.dvadell@linuxclusters.com.ar>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

   I have 6 identical PCs (HPC cluster) with MTRR problems. In older kernels, 
I had to use "mem=3300M", or else, I would get a very slowly boot (as when 
you run out of MTRRs). 

   So I thought that PAT would make this lack of MTRRs problem go away, and 
upgraded to 2.6.26.6 and 2.6.27.2, but it didn't: I still get (from dmesg)

x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 704MB of RAM.

   Most probably, I understood wrong. I read lwn.net's article [1] about PAT 
several times, Documentation/x86/pat.txt , tried to use mtrr_chunk_size= and 
mtrr_gran_size= in various combinations (as discussed in this LKML thread 
[2]), but I still don't get it.

   So, what did I miss? Am I wrong thinking that PAT is a better MTRR (wrt 
setting the cache type of the RAM)? 

Thanks in advance,
 -- Diego.

[1] http://lwn.net/Articles/282250/
"The PAT bits are more flexible and, since they live in the page table 
entries, they are difficult to run out of. They are also completely under the 
control of the operating system instead of the BIOS."

[2] http://lkml.org/lkml/2008/4/29/181
