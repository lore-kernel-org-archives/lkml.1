Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbYFUT3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbYFUT3A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 15:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbYFUT2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 15:28:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:31184 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbYFUT2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 15:28:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:from;
        b=oemsfwDE3PT29W8ijAVP+Q+34whdAsWT0Q4o3esPWI1KiQiI2zI3S26iZU7vSBAv98
         YQjGqfqw48nr/0K1GOHeE/wBDqhfdTwgA3mVZjduVl/ahTTQpJadgg7GeO1o8Ucbp7mu
         cBVd22Ks9MLtVonqEETIWQ7RmQdX3LoETtAOY=
Date: Sat, 21 Jun 2008 21:28:45 +0200
To: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: v2.6.26-rc7: BUG task_struct: Poison overwritten
Message-ID: <20080621192845.GB2992@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080621192400.GA2992@damson.getinternet.no>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, seems there was another one a bit earlier (about 5 minutes) that I
didn't notice. I don't think it helps that much, but here it is:


 =============================================================================
 BUG task_struct: Poison overwritten
 -----------------------------------------------------------------------------
 
 INFO: 0xf53ab018-0xf53ab02b. First byte 0x71 instead of 0x6b
 INFO: Allocated in copy_process+0x70/0x1090 age=110 cpu=1 pid=28664
 INFO: Freed in free_task+0x2c/0x30 age=68 cpu=0 pid=28667
 INFO: Slab 0xc1ba6cc0 objects=8 used=5 fp=0xf53aafd0 flags=0x400020c3
 INFO: Object 0xf53aafd0 @offset=12240 fp=0xf53acfb0
 
 Bytes b4 0xf53aafc0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
   Object 0xf53aafd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
   Object 0xf53aafe0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
   Object 0xf53aaff0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
   Object 0xf53ab000:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
   Object 0xf53ab010:  6b 6b 6b 6b 6b 6b 6b 6b 71 19 6f be dd 07 00 00 kkkkkkkkq.o<BE><DD>...
   Object 0xf53ab020:  71 19 6f be 6b 6b 6b 6b 6a 6b 6b eb 6b 6b 6b 6b q.o<BE>kkkkjkk<EB>kkkk
   Object 0xf53ab030:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
   Object 0xf53ab040:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
  Redzone 0xf53abf88:  bb bb bb bb                                     <BB><BB><BB><BB>          
  
  Padding 0xf53abfb0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
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
 FIX task_struct: Restoring 0xf53ab018-0xf53ab02b=0x6b
 
 FIX task_struct: Marking all objects used

