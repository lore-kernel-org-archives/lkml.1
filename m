Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbXJ3Q7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbXJ3Q7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 12:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbXJ3Q7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 12:59:08 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:34056 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbXJ3Q7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 12:59:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=gZVpUq/pVJ0nncQKLtaleRJK4UqHyXdZfMovdiCNud++tIecL+9uLbXPyhiiD7M2whg+21EFBMTYflMl3lXvFTJN7ONj5q1eNyQZa27DbBmuNHYjVy6qxb3DxR23xYu6DD/Z4tTedJ3+33zUZoKEID/+alKR8GUDuL/JrjIAtqo=
Message-ID: <c70ff3ad0710300959t2bb5f1ebp7abb51992738a08c@mail.gmail.com>
Date: Tue, 30 Oct 2007 18:59:03 +0200
From: "saeed bishara" <saeed.bishara@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: system stops sending IOs for long time
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have a performance issue with my system that runs samba server, once
in a while (6 seconds) I see that the throughput falls almost to to
zero when doing read for large file. I'm running kernel 2.6.22.10. I
don't see this issue when using kernel 2.6.12.

when observing the activity leds on my sata controller, I see that it
get off for about 1 second meaning no commands sent to the HDD for
that long time. I used the blktrace in order to have a look into the
IOs, and found that the system really stops sending commands for long
periods, here is the section of the blkparse that shows this problem:
  8,2    0    12747     5.550000000   328  D   R 108068834 + 512 [smbd]
  8,2    0    12748     5.550000000   328  D   R 108069346 + 512 [smbd]
  8,2    0    12749     5.550000000   328  D   R 108069858 + 512 [smbd]
  8,2    0    12750     5.550000000   328  D   R 108070370 + 512 [smbd]
  8,2    0    12751     5.550000000   328  U   N [smbd] 5
  8,2    0    12752     5.550000000     0  C   R 108068834 + 512 [0]
  8,2    0    12753     5.560000000     0  C   R 108069346 + 512 [0]
  8,2    0    12754     5.570000000     0  C   R 108069858 + 512 [0]
  8,2    0    12755     5.570000000     0  C   R 108070370 + 512 [0]
  8,2    0    12756     6.570000000     0  C   R 108066786 + 512 [0]
  8,2    0    12757     6.590000000   328  Q   R 108070882 + 8 [smbd]
  8,2    0    12758     6.590000000   328  G   R 108070882 + 8 [smbd]
  8,2    0    12759     6.590000000   328  P   N [smbd]
  8,2    0    12760     6.590000000   328  I   R 108070882 + 8 [smbd]
  8,2    0    12761     6.590000000   328  Q   R 108070890 + 8 [smbd]
  8,2    0    12762     6.590000000   328  M   R 108070890 + 8 [smbd]

any idea how to fix this issue?
