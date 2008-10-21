Return-Path: <linux-kernel-owner+w=401wt.eu-S1755150AbYJUSOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbYJUSOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 14:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbYJUSOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 14:14:07 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:29914 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbYJUSOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 14:14:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=MqaKwERiGXoohWQeU4ov8HONTxGssAoRNFfEZhmaS4sA+3AFMxM7aXjyytbU0bYZgz
         UWstkaWfD0T/vmNKT5Dwgg53FOhQRGe1Hf/Tn63SzJV6Syk2wrIZ5fKX4m1FwVPC5NyO
         xYqFKxBgo6R1KH3o++GvMQ8qtPNJrGu3pFfsY=
Message-ID: <e9c3a7c20810211114w5be330d3h35f859b4ea8f8af7@mail.gmail.com>
Date: Tue, 21 Oct 2008 11:14:04 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Timur Tabi" <timur@freescale.com>
Subject: Re: Best method for sending messages to user space?
Cc: linux-kernel@vger.kernel.org, "Kumar Gala" <kumar.gala@freescale.com>
In-Reply-To: <48FE1741.1000502@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48FE1741.1000502@freescale.com>
X-Google-Sender-Auth: a38d703e77063f4a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 10:54 AM, Timur Tabi <timur@freescale.com> wrote:
> I have a driver that provides services for a hypervisor that my company is
> creating.  The hypervisor can send notifications to the driver via interrupts.
> I want to send a message to user space whenever the driver receives one of the
> interrupts.  The messages don't have any payload.
>
> Should I be creating kobjects and using kobject_uevent(..., KOBJ_CHANGE) to send
> these messages?  I want to take advantage of the standard (hotplug?) user-space
> interface for this sort of thing, so that I don't need to have a custom-written
> daemon running that waits on blocking ioctl calls.
>

I really like the sysfs_notify() approach that Neil Brown has put
together for delivering md-raid events.  Now with 2.6.28 you will be
able do this from an atomic context with sysfs_notify_dirent() [1].

--
Dan

[1] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=f1282c84
