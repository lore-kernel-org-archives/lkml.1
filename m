Return-Path: <linux-kernel-owner+w=401wt.eu-S1759136AbZHROza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759136AbZHROza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 10:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758955AbZHROz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 10:55:29 -0400
Received: from mail.cs.nmsu.edu ([128.123.64.3]:34881 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825AbZHROz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 10:55:29 -0400
Message-ID: <9f97a27ccc13bd63ce99be04018b6bde.squirrel@intranet.cs.nmsu.edu>
Date: Tue, 18 Aug 2009 08:55:29 -0600
Subject: Purpose of parameter in sysfs binary read
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Linux USB" <linux-usb@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The read function pointer of the sysfs bin_attribute structure has this
signature:

ssize_t (*read)(struct kobject *kobj, struct bin_attribute *attr,
                        char *buf, loff_t offset, size_t size);

I've figured out the purpose of all the parameters except the loff_t
parameter.

Obviously it's an offset of some sort, but what is the meaning of the offset?

If I have binary data in a char* named bindata of size bsize, should it be
copied into buf+offset in something like:
  memcpy(buf+offset, bindata, bsize);

Or, is it an offset from both buf and bindata in something like:
  memcpy(buf+offset, bindata+offset, bsize-offset);

Thanks,

Rick

