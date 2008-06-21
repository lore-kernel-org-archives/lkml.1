Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbYFUS2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbYFUS2Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 14:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbYFUS2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 14:28:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:21342 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbYFUS2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 14:28:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=SMBkEAjeBhdVXDLiaPjLdPR9hnkglRJqM8d9rnTT5rEIWu9Ztb7vUvbfEpYj+VwZBm
         ZZ6S97m2vqZXgJySC8XMtqTgankBzgonNk7cQSwZriSXKbMquaEDMwCDV1Sj+eUY1jHR
         e3PKSXB6xv8BRkjld1pWFtietpMadFN5HOB/A=
Date: Sat, 21 Jun 2008 20:28:06 +0200
To: Philippe Elie <phil.el@wanadoo.fr>, oprofile-list@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: v2.6.26-rc7/oprofile: BUG: using smp_processor_id() in preemptible
Message-ID: <20080621182805.GA27417@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I decided to try oprofile too :) Here's what I did:

    # opcontrol --deinit
    Stopping profiling.
    Killing daemon.
    Opening /proc/modules: No such file or directory

This was after having collected some data. The kernel is compiled without
module support. (I can provide config if necessary)

Vegard


 opannotate[27361]: segfault at 0 ip 080d1f5b sp bfcbab6c error 4 in opannotate[8048000+117000]
 BUG: using smp_processor_id() in preemptible [00000000] code: oprofiled/27301
 caller is nmi_shutdown+0x11/0x60
 Pid: 27301, comm: oprofiled Not tainted 2.6.26-rc7 #25
  [<c028a90d>] debug_smp_processor_id+0xbd/0xc0
  [<c045fba1>] nmi_shutdown+0x11/0x60
  [<c045dd4a>] oprofile_shutdown+0x2a/0x60
  [<c045eb70>] event_buffer_release+0x10/0x40
  [<c0195f76>] __fput+0xb6/0x180
  [<c01962e9>] fput+0x19/0x20
  [<c0193297>] filp_close+0x47/0x70
  [<c013869b>] put_files_struct+0x9b/0xb0
  [<c01386f2>] exit_files+0x42/0x60
  [<c013989d>] do_exit+0x16d/0x700
  [<c014e1c6>] ? up_read+0x16/0x30
  [<c0122953>] ? do_page_fault+0x2e3/0x700
  [<c0194b90>] ? do_sync_write+0x0/0x110
  [<c0139e61>] do_group_exit+0x31/0x90
  [<c0139ecf>] sys_exit_group+0xf/0x20
  [<c010831b>] sysenter_past_esp+0x78/0xd1
  =======================
