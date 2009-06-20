Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbZFTOF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbZFTOF2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 10:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbZFTOFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 10:05:04 -0400
Received: from mail-px0-f202.google.com ([209.85.216.202]:55466 "EHLO
	mail-px0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbZFTOFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 10:05:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=PAFY9YDZ6c8L4+L503Ux32HHhxp9pJ4aSjhVEKReRp8cKjtTbkvf7IRzHtdQiYaIeA
         KFO+yj//EHm+8DfIEltmBw/sME17FBVc8yxmvuxhWcUwRhsh/7na4HjuGyjawasaRU8/
         28aijwtQK7o19+tgGj1a1VEv0bvtGJbowovHQ=
MIME-Version: 1.0
Date: Sat, 20 Jun 2009 19:35:03 +0530
Message-ID: <e42309110906200705j6a731ecay204969f639af5330@mail.gmail.com>
Subject: generic_make_request fucntion for scsi_disk
From: Ravish Tayal <ravish.tayal@gmail.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am debugging Filesystem code for USB mass storage devices.  I need
help to figure out after generic_make_request how the request is
placed to scsi disk (sd) requeset queue and than how sd qeueuecommand
to usb_storeage thread.  (in which context, is it system call context)


inside generic_make_request

1.   q = bdev_get_queue(bio->bi_bdev);  [is sd.c register queue this
queue or any other scsi file?]
2.     ret = q->make_request_fn(q, bio);  [which file contain this
make_request_fn for scsi disk driver (generic)]

As per my unsderanding flow is like
Fat_writepage ->_block_write_full_page --> blkdev_writepage-->
block_write_full_page-->submit_bh-->generic_make_request ???  (sd ??)
----> queuecommand

Please suggest any sorce file, link or document.

with thanks
Ravish
