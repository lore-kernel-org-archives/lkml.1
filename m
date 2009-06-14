Return-Path: <linux-kernel-owner+w=401wt.eu-S1763209AbZFNPyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763209AbZFNPyV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 11:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760364AbZFNPyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 11:54:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38632 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781AbZFNPyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 11:54:10 -0400
Message-ID: <4A351D22.3020404@redhat.com>
Date: Sun, 14 Jun 2009 17:54:10 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Udo van den Heuvel <udovdh@xs4all.nl>
CC: linux-kernel@vger.kernel.org
Subject: Re: crypt issue with 2.6.30/gcc 4.4.0?
References: <4A34FD06.2020204@xs4all.nl>
In-Reply-To: <4A34FD06.2020204@xs4all.nl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Udo van den Heuvel wrote:
> I am having trouble decrypting my dm-crypted disks with 2.6.30. 2.6.29.4
> works fine with the same encrypted disks.
> I've been upgrading to Fedora 11 in the past few days so now GCC 4.4.0
> is the compiler, that may (also) be a factor.
> 
> On 2.6.92.4 I see the encryption password prompt being buried by a lot
> of USB-messages from connected gear. I can 'blindly' type my password
> and asterisks appear for each letter. At the end of the password I press
> Enter; a complaint about the partition table for md1 is displayed and
> booting continues.
> With 2.6.30 I see the Password prompt being repeated, after all the USB
> messages, as soon as I press the first letter of the password. Each time
> the password is entered it is not accepted and a new Password: prompt is
> printed up to a total of three tries.

Hi,
password prompt in Fedora is handled completely in userspace in initrd
by plymouth, then it send password to cryptsetup.

You did provide neither kernel log messages nor description of changes to
your kernel config... Try run it in text mode with full kernel log,
also try enable some debug mode in plymouth and check exact error message.

Anyway, the problem is probably in some misconfiguration in you initrd
(like missing kernel module - some new module maybe needed now for your config,
bad order of module loading, device name changes of underlying device, maybe some
timing problem initialization of USB keyboard etc.) and not in kernel itself.
(Are you using mkinitrd from F11? Also see fedora bug 470740)

Milan
--
mbroz@redhat.com


