Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbYJUUmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbYJUUmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 16:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbYJUUmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 16:42:46 -0400
Received: from hs-out-0708.google.com ([64.233.178.249]:38697 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbYJUUmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 16:42:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=f+ikkABK3udaipeAtgwIQ5xQpe10/y0dJ3t51WZeZJ1B4wEmVbm4L/txV8quU519et
         U31akHW3rwaxlgknlsXwPYoRrW8nRyHaVXGgGZvuQJihqdJhtENQ+LuIC42R1ZQsYl7B
         IPPDZieagx++th8zOasShw/g+BwV3A0icBa5k=
Message-ID: <e9c3a7c20810211342n6367e7b3q67394506fe0dfc29@mail.gmail.com>
Date: Tue, 21 Oct 2008 13:42:42 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Timur Tabi" <timur@freescale.com>
Subject: Re: Best method for sending messages to user space?
Cc: linux-kernel@vger.kernel.org, "Kumar Gala" <kumar.gala@freescale.com>
In-Reply-To: <48FE3A34.5040105@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48FE1741.1000502@freescale.com>
	 <e9c3a7c20810211114w5be330d3h35f859b4ea8f8af7@mail.gmail.com>
	 <48FE30D8.6050705@freescale.com>
	 <e9c3a7c20810211316i13610410h5ec022b55c248c6a@mail.gmail.com>
	 <48FE3A34.5040105@freescale.com>
X-Google-Sender-Auth: 14e0d2f4e8bc65e0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 1:23 PM, Timur Tabi <timur@freescale.com> wrote:
> Dan Williams wrote:
>
>> fd = open("/sys/block/md0/md/array_state");
>> do {
>>       read(buf, fd, len);
>>       act_on_message(buf);
>>       select(...); /* wait for next sysfs_notify event */
>>       lseek(fd, 0, SEEK_SET); /* seek back so we can read the new state */
>> } while (1);
>
> I meant from the kernel side.  I added a call to sysfs_notify(), and I didn't
> see any sysfs entries being created, so I presume I need to set up sysfs before
> I call sysfs_notify(), but I can't figure out what that setup is.
>

sysfs_notify() will not create any files it only operates on
pre-existing attributes created via kobject_{init_and_}add().  See:
http://lxr.linux.no/linux+v2.6.27/drivers/md/md.c#L3473
http://lxr.linux.no/linux+v2.6.27/drivers/md/md.c#L3761
