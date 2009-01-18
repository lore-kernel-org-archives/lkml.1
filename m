Return-Path: <linux-kernel-owner+w=401wt.eu-S1757081AbZARVYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081AbZARVYe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 16:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbZARVYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 16:24:21 -0500
Received: from hobbit.corpit.ru ([81.13.33.150]:22972 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbZARVYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 16:24:21 -0500
Message-ID: <49739E02.9060400@msgid.tls.msk.ru>
Date: Mon, 19 Jan 2009 00:24:18 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: sam@ravnborg.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kbuild: install to a single directory
References: <alpine.LSU.2.00.0901172055100.15992@fbirervta.pbzchgretzou.qr>
In-Reply-To: <alpine.LSU.2.00.0901172055100.15992@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> Hi,
> 
> This proposed change will collect all kernel modules in the
> single directory, e.g. /lib/modules/2.6.29-rc2/kernel/, without
> any further directory structure. About 475 inodes (with
> almost-allmodconfig) less are used, which should result
> in faster directory traversal (less seeks).

While I agree that current deep-n-wide directory structure is
not very useful.. It still helps in many situations.  For
example, I sometimes need to remember which module name this
particular scsi or network or [s]ata controller needs, and
looking at /lib/modules/$foo/kernel/driver/scsi is usually
sufficient since there isn't many of them in there.  Or,
see (old, compat) -t option to modprobe(8).

In the other words, if to change anything at all, something
in-between is needed instead.  No current deep-n-wide often
single-driver-in-directory structure, and not everything in
one place either.

Maybe add a make variable to tell kbuild to use specified
directory to install modules in this dir to, or to specify
that "this module should go to the parent dir" (eliminates
many driver-in-a-dir cases).

/mjt
