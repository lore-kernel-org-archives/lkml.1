Return-Path: <linux-kernel-owner+w=401wt.eu-S1755751AbYJUUQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbYJUUQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 16:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbYJUUQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 16:16:07 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:2261 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbYJUUQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 16:16:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Cm9Q6BMJGXFtwD+MhilrOvVaMPIwYXGO4qOHeeBPBkDWqYRgisgq7/MxVNh+Shmfi8
         ioQ4IY+eqJzgm1Ag/6yG0qxtIW2u8PAOZbYUjUuSuBjTayoM0a3aAfy344bEdCvVqI5U
         x8Kq07z9YIdStRVx6f9BqFI8MW/u7Mre7y8LY=
Message-ID: <e9c3a7c20810211316i13610410h5ec022b55c248c6a@mail.gmail.com>
Date: Tue, 21 Oct 2008 13:16:04 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Timur Tabi" <timur@freescale.com>
Subject: Re: Best method for sending messages to user space?
Cc: linux-kernel@vger.kernel.org, "Kumar Gala" <kumar.gala@freescale.com>
In-Reply-To: <48FE30D8.6050705@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48FE1741.1000502@freescale.com>
	 <e9c3a7c20810211114w5be330d3h35f859b4ea8f8af7@mail.gmail.com>
	 <48FE30D8.6050705@freescale.com>
X-Google-Sender-Auth: 9073f54d247fb368
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 12:43 PM, Timur Tabi <timur@freescale.com> wrote:
> Dan Williams wrote:
>
>> I really like the sysfs_notify() approach that Neil Brown has put
>> together for delivering md-raid events.
>
> Is there any documentation for sysfs_notify?  It doesn't appear to do anything
> whenever I call it.
>

It simply allows you to write an event loop in userspace using a sysfs
attribute file descriptor.  Pseudo-example:

fd = open("/sys/block/md0/md/array_state");
do {
	read(buf, fd, len);
	act_on_message(buf);
	select(...); /* wait for next sysfs_notify event */
	lseek(fd, 0, SEEK_SET); /* seek back so we can read the new state */
} while (1);
