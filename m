Return-Path: <linux-kernel-owner+w=401wt.eu-S934869AbZAOVIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934869AbZAOVIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932731AbZAOU6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:58:30 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:42893 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934611AbZAOU63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:58:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YKECWkxkAQcC+7HzkAWjCI9pAb+UZFSRu+rOvTBSEQR+JyIzL/nYtImXe0TjHWYe7H
         XvCw9z9fJjd0yqkJSwSkzygFS/P0k978zCj83KnEa6VeIsAy688sgRaUA7vvOYhE/u0a
         mILyNYeiJOZ5notrSME/OhJeyGeVlp5t2FBp0=
Message-ID: <19f34abd0901151258u53232e89rac76c40334703fe2@mail.gmail.com>
Date: Thu, 15 Jan 2009 21:58:25 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [slab corruption] BUG key_jar: Poison overwritten
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "David Howells" <dhowells@redhat.com>,
       "Michael LeMay" <mdlemay@epoch.ncsc.mil>,
       "James Morris" <jmorris@namei.org>,
       "Stephen Smalley" <sds@tycho.nsa.gov>, "Paul Moore" <paul.moore@hp.com>,
       "Eric Paris" <eparis@redhat.com>
In-Reply-To: <20090115181612.GA27762@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <20090115181612.GA27762@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n0FL9FwM031877

On Thu, Jan 15, 2009 at 7:16 PM, Ingo Molnar <mingo@elte.hu> wrote:>> -tip testing found the rather scary looking slab corruption:>> [   35.419875] CPU0 attaching sched-domain:> [   35.420101]  domain 0: span 0-1 level CPU> [   35.425883]   groups: 0 1> [   35.428527] CPU1 attaching sched-domain:> [   35.432010]  domain 0: span 0-1 level CPU> [   35.437729]   groups: 1 0> [   37.380005] eth0: no IPv6 routers present> [   44.478286] =============================================================================> [   44.482064] BUG key_jar: Poison overwritten> [   44.482064] -----------------------------------------------------------------------------> [   44.482064]> [   44.482064] INFO: 0xf5f320c0-0xf5f320c0. First byte 0x6a instead of 0x6b> [   44.482064] INFO: Allocated in key_alloc+0xe7/0x30e age=291 cpu=1 pid=2815> [   44.482064] INFO: Freed in key_cleanup+0xd8/0xdd age=292 cpu=1 pid=2520> [   44.482064] INFO: Slab 0xc1f9cfb8 objects=21 used=2 fp=0xf5f320c0 flags=0x400000c3> [   44.482064] INFO: Object 0xf5f320c0 @offset=192 fp=0xf5f32240> [   44.482064]> [   44.482064] Bytes b4 0xf5f320b0:  7c 05 ff ff 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a |.ï¿½ï¿½ZZZZZZZZZZZZ> [   44.482064]   Object 0xf5f320c0:  6a 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b jkkkkkkkkkkkkkkk> [   44.482064]   Object 0xf5f320d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk> [   44.482064]   Object 0xf5f320e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk> [   44.482064]   Object 0xf5f320f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk> [   44.482064]   Object 0xf5f32100:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk> [   44.482064]   Object 0xf5f32110:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk> [   44.482064]   Object 0xf5f32120:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk> [   44.482064]   Object 0xf5f32130:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk> [   44.482064]   Object 0xf5f32140:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5             kkkkkkkkkkkï¿½> [   44.482064]  Redzone 0xf5f3214c:  bb bb bb bb                                     ï¿½ï¿½ï¿½ï¿½> [   44.482064]  Padding 0xf5f32174:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a             ZZZZZZZZZZZZ> [   44.482064] Pid: 2832, comm: sudo Not tainted 2.6.29-rc1-tip-01097-gf5d0b1b-dirty #16445> [   44.482064] Call Trace:> [   44.482064]  [<c018e25c>] print_trailer+0xcd/0xd5> [   44.482064]  [<c018e2dc>] check_bytes_and_report+0x78/0x94> [   44.482064]  [<c018e55c>] check_object+0xa9/0x191> [   44.482064]  [<c018eff3>] __slab_alloc+0x365/0x42c> [   44.482064]  [<c0144dda>] ? trace_hardirqs_off+0xb/0xd> [   44.482064]  [<c018f369>] kmem_cache_alloc+0x64/0xc1> [   44.482064]  [<c02d040e>] ? key_alloc+0xe7/0x30e> [   44.482064]  [<c02d040e>] ? key_alloc+0xe7/0x30e> [   44.482064]  [<c02d040e>] key_alloc+0xe7/0x30e> [   44.482064]  [<c02d1429>] keyring_alloc+0x24/0x58> [   44.482064]  [<c02d2781>] install_session_keyring_to_cred+0x43/0x92> [   44.482064]  [<c02d2d61>] lookup_user_key+0xe0/0x30b> [   44.482064]  [<c02d17ab>] keyctl_get_keyring_ID+0x12/0x2e> [   44.482064]  [<c02d22c2>] sys_keyctl+0x36/0xe3> [   44.482064]  [<c0102d55>] sysenter_do_call+0x12/0x35> [   44.482064] FIX key_jar: Restoring 0xf5f320c0-0xf5f320c0=0x6b> [   44.482064]> [   44.482064] FIX key_jar: Marking all objects used>> Config attached. The system seemed to stay intact after this incident.

Are you sure this is the right config?
# Security options## CONFIG_KEYS is not set
...sys_keyctl() returns -ENOSYS...!?

Vegard
-- "The animistic metaphor of the bug that maliciously sneaked in whilethe programmer was not looking is intellectually dishonest as itdisguises that the error is the programmer's own creation."	-- E. W. Dijkstra, EWD1036ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
