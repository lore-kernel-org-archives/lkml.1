Return-Path: <linux-kernel-owner+w=401wt.eu-S1756402AbYFLGlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbYFLGlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 02:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbYFLGlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 02:41:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:8608 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbYFLGlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:41:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:from;
        b=kr5n+1KiyRS9gz/83mpSYamPeWteSiJGQ1fuEl45wQa4dHzdDUUXpj1Zm6qHt/At3K
         CvjxqVkJcFMhwSxtfFaw/WB46mGRxnDIlXbjF89FoEAs2++1I68wlMTVx5SQUB50U3dN
         56jxPwk98JT9e/sE3bjmhaUK/BeR8LmisNw4w=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 00/18] misc generic ide stuff
Date: Thu, 12 Jun 2008 08:40:52 +0200
Message-Id: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

here are some generic ide conversion patches. The first 12 are what i thought
you suggested :) concerning prepping the ide-cd code for the generic layer. The
remaining 6 are what i've done so far wrt removing ide_atapi_pc from the ide
drivers. It is obvious that this is not trivial and I basically tiptoe around the
landmines in the IRQ handler and request issue paths :). This raises also
several questions:

1. ide-cd uses the cdrom_info struct for e.g. dma status notification, the other
ide drivers use it per packet command in pc->flags. Well the last are kinda too
much to carry for _each_ command and i'm thinking maybe put all that in the
ide_drive_t and make it generic enough to fit all drivers. This way
pc->callback() can also be harboured there. One concern might be when a flag is
strictly per packet command which could be put somewhere else (maybe in the
struct request since it already has members when it is used as a packet
command).

2. Can all that pc->xferred, pc->b_count, pc->errors and pc->cur_pos accounting
be safely mapped to a rq? I see some discrepancies like is pc->buf_size ==
rq->data_len, what about pc->req_xfer? I'll have a more detailed look at those
when i have more spare time later.

3. (I'm sure there are more :))
