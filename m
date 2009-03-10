Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbZCJXeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbZCJXeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 19:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755098AbZCJXeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 19:34:04 -0400
Received: from mail-bw0-f178.google.com ([209.85.218.178]:46864 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbZCJXeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 19:34:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=GEIkRqDE/xSsvbVGoEzjEVQlEhb5rmH02oicBXhi9197FYU0fbXyKcveND13bVTk6T
         IeoXLmeVgSeGi4AITCyaTVYl5WCtOzlMTOf4Bbq0Dy+WZmrZG8FdfP3oJKEataIgHzeX
         A5VBTMkbcKzHuElMQZjMU6Iog055NWJ48Emik=
Message-ID: <49B6F8DF.9040409@gmail.com>
Date: Tue, 10 Mar 2009 17:33:51 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: porte64@free.fr
CC: linux-kernel@vger.kernel.org
Subject: Re: read-only partitions: does the policy apply to all metadata ?
References: <355270241.1702481236702404399.JavaMail.root@spooler8-g27.priv.proxad.net>
In-Reply-To: <355270241.1702481236702404399.JavaMail.root@spooler8-g27.priv.proxad.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

porte64@free.fr wrote:
> Hello,
> 
> When a partition is mounted as read-only, does the kernel
> really prevent ANY byte to be written to it, including
> any metadata ?
> 
> (i am thinking here about file attributes -- last access time,
> as well as meta information about filesystem/blocks
> description etc ...).

As far as I know any of the visible attributes (last access, etc.) 
cannot be modified. However, mounting read-only may still write to the 
filesystem if the block device is writable, for example with ext3/ext4 
if the file system was not unmounted cleanly last time and the journal 
needs to be replayed.

> 
> And is the policy implemented in every filesystem type driver
> or at some abstraction level (as if the write() and like
> system calls were designed to return an error).
> 
> Unfortunately, on common (all?) hard drives, there seems
> to be no switch to set the device microcode in read-only
> mode.
> 
> By the way, this makes me also thing about memory cards
> with locks: is it a real protection or it is just a setting
> which tells the kernel that it *SHOULD* mount the device
> read-only ?

Normally the card reader indicates to the OS that the device is 
read-only, and then the kernel will mount it only read-only. However, 
note that some crappy SD card readers don't implement the write protect 
switch detection and will allow writing to a card marked read-only.

> 
> Please include my private address if you answer; i posted to the
> list because in some other forums we did not come up
> with a clear answer, so this is my last chance to get a
> definite done. However i didn't subscribe to the list as
> i have realized i am not able to help unfortunately:
> operating systems are the most complex thing ever design by humans !
> 
> Best regards
> Phil

