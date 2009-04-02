Return-Path: <linux-kernel-owner+w=401wt.eu-S1764470AbZDBRly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764470AbZDBRly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 13:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbZDBRlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 13:41:44 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:49334 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558AbZDBRln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:41:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:date:subject:from:to:cc
         :user-agent:mime-version:content-type:content-transfer-encoding
         :x-priority:importance;
        b=PI8OAPQA9dikQRW5Hu3sK4GxVdQC2NWkPvqJojjfkOByMz643VjujzI5vt1cNyphkw
         DhNDULY3fHI2w2ShgQLSBBMP5zXif+64JrqiTzzCMjJbElrNmSuoXvE/Wyfz0ovDUg1M
         64rjQh//1qJqCLBsfbdEht5//x2rt1PeS3cgU=
Message-ID: <6c62e9d84a16902aebba9438b4e299d9.squirrel@localhost>
In-Reply-To: <159a870e0904020702q3c528b8u77cebf834d607e3f@mail.gmail.com>
References: <159a870e0904020702q3c528b8u77cebf834d607e3f@mail.gmail.com>
Date: Thu, 2 Apr 2009 12:41:37 -0500 (CDT)
Subject: Re: RAID performance / tuning?
From: david.hagood@gmail.com
To: "Tiago Freire" <tiago.freire@gmail.com>
Cc: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Why is it that software RAID on current systems still gets less
> performance than hardware counterparts?

Part of it can be crappy disk interfaces: I was running software raid with
2 SATA-SIL cards, and would frequently be disk-bound with the CPU still
largely idle.

The cards were incapable of talking to more than one drive at a time. They
didn't support command queuing on the drives.

As a result, the system would set up a stripe, queue up the writes, then
have to wait as each write for EACH DISK in the 7 disk array was carried
out.

On a good hardware RAID controller, the disks can be written in parallel,
and the controller will support command queuing - so disk writes can be
run in parallel, and the writes themselves can be better optimized by the
disks.


