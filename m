Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbZAaNgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbZAaNgh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 08:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbZAaNg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 08:36:29 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:39940 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbZAaNg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 08:36:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=MPteO/Mn7pz4OhE+eF4qpBFa+cS3TXBcR2tShocdC6F39FiQRfpQjeTYSENkS3Ol0S
         vnQ2VZ4vxYsja96A263h9eTwGql+hOTzVckXCFhEpDOmff8/jz7MG/8FJJQ7y9VAo6cH
         4q2w13oGO1CPeJhzLMtrqGz3xHX2L3GF4DJT4=
MIME-Version: 1.0
Date: Sat, 31 Jan 2009 14:36:26 +0100
Message-ID: <6bd94bae0901310536l2cd42fa1off60ee066fa0096b@mail.gmail.com>
Subject: Spurious Filesystem corruption with ext3 + large (<400GB) hw RAID 
	partition + SMP
From: Manfred Wassmann <tux.wassmann@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm experiencing spurious filesystem corruption problems with ext3 on
a partition larger than 400 GB on a hardware SATA RAID.

The problems first occured on an Intel dual core system with a custom
installation DVD which uses a 32 bit 2.6.26 kernel with SMP enabled
and a 4GB memory limit. The problems occured only randomly but it was
possible to reproduce them reliably with a standard Ubunu installation
disk using a 2.6.27-7 kernel (apparently also 32bit SMP kernel w 4GB
limit).
When installing Ubuntu a message appears in the kernel log stating:
"EXT3-fs error (device sda6): ext3_vlid_block_bitmap: Invalid block
bitmap - block_group = 3076, block = <some large number>"
This message is the first indication of any problem, the filesystem is
then remounted readonly and the installation stops understandably.

The problem does only occur with an ext3 filesystem, installation
using an xfs filesystem completes without error.

Furthermore with the installation from my custom installation DVD
succeeded, which installs a prebuild Debian etch system featuring a 64
bit monolithic 2.6.26 kernel, i was able to stress the system to its
limits using the stress and dbench programs without any sign of
filesystem corruption.

As XFS does substantially outperform ext3 under the given
circumstances I'm going to use that but if someone wants to
investigate the problem and needs further details I'll do my very best
;-)

regards Manfred Wassmann
