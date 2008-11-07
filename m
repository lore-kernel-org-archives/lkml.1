Return-Path: <linux-kernel-owner+w=401wt.eu-S1755119AbYKGBVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119AbYKGBVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 20:21:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750784AbYKGBUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 20:20:55 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:45644 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbYKGBUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 20:20:54 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=HZwU_xYx9yjQs4nunmoA:9 a=qEbVfmN-rPMq7PB8LhM6Tq9IqVEA:4 a=Akbl9xRpahQA:10 a=AzoIOWn_O8AA:10
Message-ID: <491397F2.6050106@shaw.ca>
Date: Thu, 06 Nov 2008 19:20:50 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: andy <rootstrap@googlemail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: accessing file operations directly in the kernel
References: <fa.8yqIDPH3sfvHfyr9YeQyeb9HG/Q@ifi.uio.no>
In-Reply-To: <fa.8yqIDPH3sfvHfyr9YeQyeb9HG/Q@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

andy wrote:
> Hi,
> 
> I am dealing with an interesting situation, which I have to access a
> serial device driver
> from the kernel space. I tried to use sys_open, sys_ioctl ... but
> there is a problem
> with the file descriptors.  Now, I started using direct calls to the
> drivers functions
> driver_open, driver_ioctl... passing the *inode from user_path_walk(),
> but it doesn't
> seem that works right. This serial device is going to be used only
> from the other
> module that runs in the kernel.

For some reason this kind of question (using file operations inside the 
kernel) gets asked a lot. The short answer is that if you're asking it, 
you likely have a wrong design. It's just not the right thing to do. For 
one thing, file descriptors belong to a process, so just stealing the FD 
space from some random process is unlikely to do the right thing.

If you really need to do this, adding hooks to the serial device driver 
would seem a more logical thing to do.. but even that seems a suspicious 
design. It would be best if you explained what it is you're actually 
trying to accomplish.
