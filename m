Return-Path: <linux-kernel-owner+w=401wt.eu-S1759484AbYGQNVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484AbYGQNVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 09:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755969AbYGQNUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 09:20:50 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:40673 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758791AbYGQNUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 09:20:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ouCZkG+Ra6DqEbsz1ehSrJBcpV4DstYBLGHQ1wsNPftYn2ZZfI0OGsnrfwirEh0M1t
         +Mz+nyAFC5Fi0rUj5z1oPt9SVUwUouFl24K4h7YJnA+urRwBqaJAIYmGt3Lc8RWdGO6X
         FjRgdxHg9835VnoLuGud2xOXQVqJiNaFxhBt0=
Message-ID: <19f34abd0807170620g39ab942bl592ea3fa3fa0dab@mail.gmail.com>
Date: Thu, 17 Jul 2008 15:20:47 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Josef Bacik" <josef@toxicpanda.com>
Subject: Re: ext3 on latest -git: BUG: unable to handle kernel NULL pointer dereference at 0000000c
Cc: linux-ext4@vger.kernel.org, sct@redhat.com, akpm@linux-foundation.org,
       adilger@sun.com, "Johannes Weiner" <hannes@saeurebad.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1b7401870807170613y747baa7by158177047cc7e28@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807170551q4fbb862bu270297cfd76a69be@mail.gmail.com>
	 <1b7401870807170613y747baa7by158177047cc7e28@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 3:13 PM, Josef Bacik <josef@toxicpanda.com> wrote:
> On Thu, Jul 17, 2008 at 8:51 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> Hi,
>>
>> I get this with both clean v2.6.26 and latest -git
>> (33af79d12e0fa25545d49e86afc67ea8ad5f2f40):
>>
>
> Thanks for the report, do you happen to have any messages above the
> panic message that would indicate if there was some sort of fs error
> that was hit before the panic?  That would help me figure out what
> exactly happened.  Thanks,

Yeah, the full log exists at

    http://folk.uio.no/vegardno/linux/log-1216293934.txt

I think this is the interesting part:

kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: mounting fs with errors, running e2fsck is recommended
EXT3 FS on loop0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
EXT3-fs error (device loop0): ext3_free_blocks_sb: bit already cleared
for block 1507
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 1050159, count = 1
EXT3-fs error (device loop0) in ext3_reserve_inode_write: IO failure
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 2048, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 102, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 496, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 245, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 1, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 8192, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 8192, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 256, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 1216293753, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 1216293753, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 1703965, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 257875, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 1, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 1216293738, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 15552000, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 1, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 11, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 128, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 52, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 6, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 1, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 3246399477, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 860559364, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 1659021227, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 2723221558, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 458752, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 8, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 11, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 1092049505, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 2823687499, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 2276435116, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 2703362334, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 258, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 1216293738, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 58, count = 13
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 327, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 1048576, count = 1
EXT3-fs error (device loop0): ext3_free_blocks: Freeing blocks not in
datazone - block = 1, count = 1
BUG: unable to handle kernel NULL pointer dereference at 0000000c
IP: [<c01fd1e0>] journal_dirty_metadata+0xa0/0x160

Would it also help to reproduce with jbd/ext3 debug enabled? (If it
isn't already.)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
