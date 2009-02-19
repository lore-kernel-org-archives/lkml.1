Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbZBSMId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbZBSMId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 07:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbZBSMIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 07:08:23 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:58974 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbZBSMIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 07:08:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=iE5g4wWI+eVzPXeYWnp5kAFZR2u81Go7scE0Xg+xVUx5lddQp+HI4fSc/x81ODQOAB
         ymIP6Uw1iWCL43hZk6UMqYaFwznqL3ghL2d+paTeaqHC/0iHZGvjzfDQrBX8D+Qmti8l
         ZJyFnQaCZ/71oBUR/XB5j/3mXFsVKUZDYfze8=
MIME-Version: 1.0
Date: Thu, 19 Feb 2009 14:08:20 +0200
Message-ID: <ce513bcc0902190408j174807a6t73300c8b8fd3c708@mail.gmail.com>
Subject: Disable aggregation of requests to a block device
From: Erez Zilber <erezzi.list@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm running I/O to a block device (which is an iSCSI device, but that
shouldn't matter), usually with transfer length = 128kB. From time to
time, I see that 2 128kB commands get aggregated to a single 256kB
command, which is bad for me because the resources that I allocate are
based on 128kB commands. I could limit the command size by setting
/sys/block/sdX/queue/max_sectors_kb to 128kB, but sometimes I expect
larger commands (e.g. 512kB), and I don't want the block layer to
split them into smaller commands.

My question is: can I disable this aggregation? If yes, how? Else, is
there another solution?

Thanks,
Erez
