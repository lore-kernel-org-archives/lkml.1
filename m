Return-Path: <linux-kernel-owner+w=401wt.eu-S1759237AbXLTBf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237AbXLTBf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758553AbXLTBeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:34:31 -0500
Received: from science.horizon.com ([192.35.100.1]:16850 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754650AbXLTBeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:06 -0500
Date: 19 Dec 2007 20:33:55 -0500
Message-ID: <20071220013355.3900.qmail@science.horizon.com>
From: linux@horizon.com
To: linux-kernel@vger.kernel.org, lkml@rtr.ca
Subject: Re: RFC: permit link(2)  to work across --bind mounts ?
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why does link(2) not support hard-linking across bind mount points
> of the same underlying filesystem ?

Whenever we get mount -r --bind working properly (which I use to place
copies of necessary shared libraries inside chroot jails while allowing
page cache sharing), this feature would break security.

mkdir /usr/lib/libs.jail
for i in $LIST_OF_LIBRARIES; do
	ln /usr/lib/$i /usr/lib/libs.jail/$i
done
mount -r /usr/lib/libs.jail /jail/lib
chown prisoner /usr/log/jail
mount /usr/log/jail /jail/usr/log
chrootuid /jail prisoner /bin/untrusted &

Although protections should be enough, but I'd rather avoid having the
prisoner link /jail/lib/libfoo.so (write returns EROFS) to /jail/usr/log
where it's potentially writeable.
