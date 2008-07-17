Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbYGQOo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbYGQOo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 10:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbYGQOot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 10:44:49 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:17678 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbYGQOos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 10:44:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eqw9J1KuW9X206smSlbzDC8Hqgvsxf/CpTGUIt/PuSOHx2/tFvCdy4b54gV1W0TJ02
         0ceLQEHQcyq0z+aIzukhBtf1CW71hIrHuBP3oY6N+ygGtrKuZNSjMT1jymRBW3Igm9pV
         bkLN9DCHZ94JN3FOpDLM2sbbwFl6UcdKNlG68=
Message-ID: <19f34abd0807170744r79e46a78odfcfbd67687d2ceb@mail.gmail.com>
Date: Thu, 17 Jul 2008 16:44:47 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Josef Bacik" <jbacik@redhat.com>
Subject: Re: ext3 on latest -git: BUG: unable to handle kernel NULL pointer dereference at 0000000c
Cc: "Josef Bacik" <josef@toxicpanda.com>, linux-ext4@vger.kernel.org,
       sct@redhat.com, akpm@linux-foundation.org, adilger@sun.com,
       "Johannes Weiner" <hannes@saeurebad.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20080717141655.GD14133@unused.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807170551q4fbb862bu270297cfd76a69be@mail.gmail.com>
	 <1b7401870807170613y747baa7by158177047cc7e28@mail.gmail.com>
	 <19f34abd0807170620g39ab942bl592ea3fa3fa0dab@mail.gmail.com>
	 <1b7401870807170634u14492a53k3931ddcddbd1e098@mail.gmail.com>
	 <19f34abd0807170639p838d14blc9a13d2104313f38@mail.gmail.com>
	 <20080717135746.GB14133@unused.rdu.redhat.com>
	 <19f34abd0807170725p13e81e3dq4daad32ad2a83931@mail.gmail.com>
	 <20080717141333.GC14133@unused.rdu.redhat.com>
	 <19f34abd0807170735p5d2cba31kec3fb65c5b8c7b3f@mail.gmail.com>
	 <20080717141655.GD14133@unused.rdu.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 4:16 PM, Josef Bacik <jbacik@redhat.com> wrote:
> On Thu, Jul 17, 2008 at 04:35:16PM +0200, Vegard Nossum wrote:
>> On Thu, Jul 17, 2008 at 4:13 PM, Josef Bacik <jbacik@redhat.com> wrote:
>> > On Thu, Jul 17, 2008 at 04:25:49PM +0200, Vegard Nossum wrote:
>> >> On Thu, Jul 17, 2008 at 3:57 PM, Josef Bacik <jbacik@redhat.com> wrote:
>> >> > Can you try this patch out and see if it fixes the problem?  I didn't compile
>> >> > test it, so you may need to tweak somethings, but it should work.  Thanks,
>> >> >
>> >> > Signed-off-by: Josef Bacik <jbacik@redhat.com>
>> >>
>> >> Nope, seems to be the same problem:
>> >>
>> >> kjournald starting.  Commit interval 5 seconds
>> >> EXT3-fs warning: mounting fs with errors, running e2fsck is recommended
>> >> EXT3 FS on loop0, internal journal
>> >> EXT3-fs: mounted filesystem with ordered data mode.
>> >> EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks in
>> >> system zones - Block = 16, count = 1
>> >> EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks in
>> >> system zones - Block = 32, count = 1
>> >> EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
>> >> datazone - block = 262144, count = 1
>> >> BUG: unable to handle kernel NULL pointer dereference at 0000000c
>> >> IP: [<c01fd210>] journal_dirty_metadata+0xa0/0x160
>> >>
>> >> Full log at http://folk.uio.no/vegardno/linux/log-1216304953.txt
>> >>
>> >>
>> >
>> > Ok, this should do it then.  Thanks,

-ENOLUCK

EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 524288, count = 1
EXT3-fs error (device loop0) in ext3_free_blocks_sb: IO failure
BUG: unable to handle kernel NULL pointer dereference at 0000000c
IP: [<c01fd200>] journal_dirty_metadata+0xa0/0x160

It did seem to get further, though.

http://folk.uio.no/vegardno/linux/log-1216306142.txt


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
