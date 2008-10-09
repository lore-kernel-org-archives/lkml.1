Return-Path: <linux-kernel-owner+w=401wt.eu-S1760428AbYJIRx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760428AbYJIRx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 13:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759024AbYJIRxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 13:53:47 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:42052 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbYJIRxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 13:53:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=ZKjURPMKLC8uPc5J/yqPCxPdkbYDoCb832qQnSiDzlh5UP5rTyGpyNnkuReknJnuZg
         aoyU7XRyO0wyEXIzTtmAEHz5tcHHLlYgj1Ol3TWqRkdlhE1bFeJMzvCG723nCHkFHyt5
         ZP2WXmWCzAGqZ+1nDieA+k+XcF8Hm9tK75waw=
Message-ID: <efa8e58e0810091053s4b1d25b7u621ee92be84d2041@mail.gmail.com>
Date: Thu, 9 Oct 2008 19:53:45 +0200
From: "=?UTF-8?Q?Rune_V._Sj=C3=B8en?=" <rvsjoen@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: NAPI enabled driver (tg3) silent packet loss ?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am sending frames to a host using, all the frames are accounted for
in the rx_ucast_packets counter of the device.
However the application shows a substantial packet loss. I assume that
the rx_ucast_packets counter is incremented when the frame is received
and then it is put into the ring buffer. I am having a hard time
figuring out where these packets are lost, and my suspicion lies with
the NAPI enabled tg3.

If the ring buffer overflows will the driver overwrite/drop packets
without incrementing any counters ? That would explain why the packets
are counted as received and then lost (by not being passed to the next
layer).

-- 
Rune V. Sjoen
You always pass failure on the way to success
