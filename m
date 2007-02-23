Return-Path: <linux-kernel-owner+w=401wt.eu-S932480AbXBWPGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480AbXBWPGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 10:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932515AbXBWPGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 10:06:18 -0500
Received: from ik-out-1112.google.com ([66.249.90.182]:1920 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932480AbXBWPGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 10:06:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B2Dp+VbE4+wiZzqMPjk3eqU27wCw649tNDOHDrtZiGcpvnc5wyGxSNR1txRh34mMko0Nl+Wxn0VlmD64YviC3SaR+bRV86GANJO8rDh191gCBaDIOnF4vSHm6zKFM1UlFI8yK0KbhWvquV2ueNb9LbOYWfs78KtAvBuT/D/vXl0=
Message-ID: <d120d5000702230706u4e7576du6661ce1b58e058aa@mail.gmail.com>
Date: Fri, 23 Feb 2007 10:06:14 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Pete Zaitcev" <zaitcev@redhat.com>
Subject: Re: input.c: start on release
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070222212919.850ceafe.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070222212919.850ceafe.zaitcev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/23/07, Pete Zaitcev <zaitcev@redhat.com> wrote:
> Here's a curious code I found in drivers/input/input.c (2.6.21-rc1):
>
> void input_release_device(struct input_handle *handle)
> {
> ....
>        if (handle->handler->start)
>                handle->handler->start(handle);
> }
>
> Is the above supposed to be this way, or you meant ->stop here?

It should be ->start(). You are probably confused a little by the name
of the function. input_release_device() is called when userspace
issues ioctl(fd, EVIOCGRAB, 0) releasing (or ungrabbing) the device
(as opposed to xxx_release(file, inode) type functions that are called
when last user of a file drops off). In our case we want to give
handlers a chance to resume their control over device. Right now
standard keyboard driver uses start method do bring back in sync LED
state of a keyborad-like device after it was released (ungrabbed).

>
> The commit comment says:
>        Input: fix list iteration in input_release_device()
> It says me precisely nothing about the way it's supposed ot be, sorry...
>

It reason for ->start was explained in the patch it was introduced in,
the changeset you are referring to literally fixes issue with
iteration through list in this function.

-- 
Dmitry
