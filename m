Return-Path: <linux-kernel-owner+w=401wt.eu-S1766624AbXECVGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766624AbXECVGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 17:06:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S637742AbXECVGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 17:06:24 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:43229 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S637750AbXECVGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 17:06:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=g1HwXU1RwQYMCTdZZvxn//W/Z/a59PJ7dY1ChXySf13gTb4tFpVqXQZvsJUJBl5JQr/RbU/hmuMJoz6gw8bTFi3F8RC3ETpAdxfGgXGSg2iR8qdl4WtWpDHPfJxs2buGbgUhz9W6ktR481Fju5p3xvIfqu8PaOSHGrBviyh/dBw=
Message-ID: <528646bc0705031406v5560d661m8fa1c3e2ea155ddb@mail.gmail.com>
Date: Thu, 3 May 2007 15:06:21 -0600
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Need help on block device error handling.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: af6307712c9461a7
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've got a device driver for the Xilinx SystemACE CompactFlash
interface that I'm working on and I'm having problems adding error
handling and notification.  Specifically, I need to deal with the case
where the CF card might get pulled out by the user at any time without
notice.  While this situation will obviously result in data loss, I
need to make sure that the system is able to recover gracefully (ie.
the user will be ticked if it hangs or crashes.  :)

So, here are my questions.
- When a new CF is inserted/removed, how should I notify the
block/filesystem layer?
- If the CF is removed mid-transfer, how do I abort all pending bios
and block new requests?  What is the impact on user space processes
using the device, will they get signaled?

AFAICT, I've got two options.  One is to use the media_changed() and
revalidate_disk() so the block layer can determine when things have
changed.  However, I cannot figure out how to force all activity to
stop when the CF is removed while the device is still open.

The other seems to be not call add_gendisk() until media is inserted,
and then call del_gendisk() when it is removed, but I don't know if
this is safe, and it still doesn't solve the problem of cancling
pending transactions and forcing the block layer to close the device.

Should I be using invalidate_partition() for this?

Cheers,
g.

-- 
Grant Likely, B.Sc. P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195
