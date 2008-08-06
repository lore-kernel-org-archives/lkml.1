Return-Path: <linux-kernel-owner+w=401wt.eu-S1763331AbYHFJcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763331AbYHFJcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 05:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755764AbYHFJck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 05:32:40 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:33842 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162AbYHFJcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 05:32:39 -0400
Subject: request->ioprio
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Wed, 06 Aug 2008 18:32:38 +0900
Message-Id: <1218015158.4419.58.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CCing LKML)

Hi Jens, Rusty,

Trying to implement i/o tracking all the way up to the page cache (so
that cfq and the future cgroup-based I/O controllers can schedule
buffered I/O properly) I noticed that struct request's ioprio is
initialized but never used for I/O scheduling purposes. Indeed there
seems to be one single user of this member: virtio_blk. Virtio uses
struct request's ioprio in the request() function of the virtio block
driver, which just copies the ioprio value to the output header of
virtblk_req.

Is this the intended use of struct request's ioprio? Is it OK for device
drivers to use it? If the answer two the previous to questions is no I
would like to send some clean-up patches.

- Fernando

