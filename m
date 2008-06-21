Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbYFUTYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbYFUTYf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 15:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbYFUTYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 15:24:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:31098 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbYFUTYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 15:24:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=hYAlRplD92NBA+cHecWBZmWVD84nMicONWLs84RIMG5XX1TWUN7+HeCfU+vp5SSD0I
         H0hm48YQzSD5arOyi0ltEkVhtOE5O9nCbVw39ctIHPegpCGMdoiiqeIdl6UeIckSvXgF
         ut1HMLVg3nidlsDpVrmMIPzIFwaZz+UueXu9A=
Date: Sat, 21 Jun 2008 21:24:00 +0200
To: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: v2.6.26-rc7: BUG task_struct: Poison overwritten
Message-ID: <20080621192400.GA2992@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I don't really know what to do about this. The stacktrace is utterly
uninteresting, too. Maybe you can extract some information from it?
I was running lmbench and hotplug/-unplugging CPUs, some network-
exercising code, and a grep on /sys.

I have the config and vmlinux with debugging symbols if this is needed.

Thanks.


Vegard


 =============================================================================
 BUG task_struct: Poison overwritten
 -----------------------------------------------------------------------------
 
 INFO: 0xeb2f3018-0xeb2f302b. First byte 0x35 instead of 0x6b
 INFO: Allocated in copy_process+0x70/0x1090 age=326 cpu=1 pid=2109
 INFO: Freed in free_task+0x2c/0x30 age=283 cpu=0 pid=19516
 INFO: Slab 0xc1974480 objects=8 used=7 fp=0xeb2f2fd0 flags=0x400020c3
 INFO: Object 0xeb2f2fd0 @offset=12240 fp=0x00000000
 
 Bytes b4 0xeb2f2fc0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
   Object 0xeb2f2fd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
   Object 0xeb2f2fe0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
   Object 0xeb2f2ff0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
   Object 0xeb2f3000:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
   Object 0xeb2f3010:  6b 6b 6b 6b 6b 6b 6b 6b 35 cc 4a 6a 1f 08 00 00 kkkkkkkk5<CC>Jj....
   Object 0xeb2f3020:  35 cc 4a 6a 6c 6b 6b 6b 6a 6b 6b eb 6b 6b 6b 6b 5<CC>Jjlkkkjkk<EB>kkkk
   Object 0xeb2f3030:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
   Object 0xeb2f3040:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Redzone 0xeb2f3f88:  bb bb bb bb                                     <BB><BB><BB><BB>            
  Padding 0xeb2f3fb0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
 Pid: 1326, comm: udevd Not tainted 2.6.26-rc7 #25
  [<c018f3fa>] print_trailer+0xaa/0xe0
  [<c018f4cb>] check_bytes_and_report+0x9b/0xc0
  [<c018f8b3>] check_object+0x193/0x1f0
  [<c019047b>] __slab_alloc+0x44b/0x5d0
  [<c01909e3>] kmem_cache_alloc+0xb3/0xe0
  [<c01345c0>] ? copy_process+0x70/0x1090
  [<c01345c0>] ? copy_process+0x70/0x1090
  [<c01345c0>] copy_process+0x70/0x1090
  [<c017ff49>] ? remove_vma+0x49/0x60
  [<c01356d7>] do_fork+0x57/0x280
  [<c0180a8a>] ? do_munmap+0x18a/0x1f0
  [<c0180b36>] ? sys_munmap+0x46/0x60
  [<c010652f>] sys_clone+0x2f/0x40
  [<c010831b>] sysenter_past_esp+0x78/0xd1
  =======================
 FIX task_struct: Restoring 0xeb2f3018-0xeb2f302b=0x6b
 
 FIX task_struct: Marking all objects used

