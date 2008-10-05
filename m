Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbYJEOCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbYJEOCQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 10:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbYJEOCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 10:02:04 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:56551 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbYJEOCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 10:02:03 -0400
Message-ID: <48E8C8AB.3010308@s5r6.in-berlin.de>
Date: Sun, 05 Oct 2008 16:01:15 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Thiago Lacerda <thiagotbl@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Questions about mmap
References: <3fedcc3b0810050621y3f44417ag605ee75dd0389100@mail.gmail.com> <3fedcc3b0810050624m19bfd701n82b70ca81887c3fc@mail.gmail.com>
In-Reply-To: <3fedcc3b0810050624m19bfd701n82b70ca81887c3fc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thiago Lacerda wrote:
> typedef struct hashtable {
>    flow_t *hashBuckets[X]; // X is a natural number
>    unsigned int size;
> } Hastable;
> 
> 
> So, my question is: Can I mmap the hashtable struct and access
> directly from userspace? I'm afraid that this could turn on mess
> because of the array of pointers.
> If it's possible, does anyone know a piece of code that can match my
> problem? I've been googling and I just find codes dealing with structs
> itself, not pointers.

If you require portability, you can only use integer types of fixed size
in kernel<->userspace ABIs.  Pointers can then be exchanged as __u64
under the assumption that pointers not wider than 64 bits.  See for
example the FW_CDEV_IOC_QUEUE_ISO ioctl in include/linux/firewire-cdev.h.
-- 
Stefan Richter
-=====-==--- =-=- --=-=
http://arcgraph.de/sr/
