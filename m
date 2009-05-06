Return-Path: <linux-kernel-owner+w=401wt.eu-S1759077AbZEFHXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077AbZEFHXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 03:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758769AbZEFHWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 03:22:39 -0400
Received: from smtp11.mail.tnz.yahoo.co.jp ([203.216.226.139]:34927 "HELO
	smtp11.mail.tnz.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758498AbZEFHWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 03:22:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=yj20050223; d=yahoo.co.jp;
  h=Received:X-Apparently-From:Message-ID:From:To:Subject:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:X-MSMail-Priority:X-Mailer:X-MimeOLE;
  b=C/vkOlJguP9Dwaxi7FbFynMr7fdbgue0vTjOqS8osRoDTGHo81N4rH9i3DuUjsxQ9tUpM+WKlL6vMXW2LLKsQM63/9UuNSz5cnesm7nHHHwGWWGbdsbxe3R15okhnYNd  ;
X-Apparently-From: <n0diamond@yahoo.co.jp>
Message-ID: <BB8F41726E2941CEB399F732BB3ED9E5@DIAMOND8600>
From: "Norman Diamond" <n0diamond@yahoo.co.jp>
To: <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>
Subject: sg timeout problem
Date: Wed, 6 May 2009 16:15:45 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-2022-jp";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct sg_io_hdr sg_io;
[...]
sg_io.timeout = UINT_MAX;
[...]
ioctl(fd, SG_IO, &sg_io);

As far as I can tell, if sg is running on top of LIBATA, the infinite
timeout is honoured.

But if sg is running on top of an actual SCSI driver, someone aborts the
ioctl after 3 seconds.  The ioctl returns success even though the operation
didn't complete.  I tried this with two Adaptec drivers and one NinjaSCSI 
driver with 100% repro.

What am I missing?  I need the call to run to completion. 

--------------------------------------
Power up the Internet with Yahoo! Toolbar.
http://pr.mail.yahoo.co.jp/toolbar/
