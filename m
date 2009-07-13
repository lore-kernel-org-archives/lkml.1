Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbZGMRW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbZGMRW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 13:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756631AbZGMRW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 13:22:59 -0400
Received: from smtp.mppmu.mpg.de ([134.107.24.58]:51263 "EHLO
	smtp.mppmu.mpg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536AbZGMRW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 13:22:57 -0400
X-Greylist: delayed 1052 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jul 2009 13:22:57 EDT
Date: Mon, 13 Jul 2009 19:22:51 +0200 (CEST)
From: Peter Breitenlohner <peb@mppmu.mpg.de>
To: Karel Zak <kzak@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng v2.16-rc2 -- shlib versions
In-Reply-To: <alpine.LNX.2.00.0907131900290.31109@pcl321.mppmu.mpg.de>
Message-ID: <alpine.LNX.2.00.0907131913010.31109@pcl321.mppmu.mpg.de>
References: <20090702181031.GB4122@nb.net.home> <alpine.LNX.2.00.0907131900290.31109@pcl321.mppmu.mpg.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jul 2009, Peter Breitenlohner wrote:

> On Thu, 2 Jul 2009, Karel Zak wrote:
>
>> The second util-linux-ng 2.16 release candidate is available at
>>
>>   ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/v2.16/
>> 
>> Feedback and bug reports, as always, are welcomed.
>
> Hi Karel,
>
> I just tried to build util-linux-ng-2.16-rc2 (i686/x86_64 linux-gnu
> with gcc-3.4.6, libc-2.3.6), but in order to succeed I had to apply the
> attached patch (#include <stdarg.h> from shlibs/blkid/src/blkidP.h).

The choice of shared library versions from util-linux-ng-2.16-rc2:
 	libblkid.so.1 -> libblkid.so.1.0.0
 	libuuid.so.1 -> libuuid.so.1.0.0
is somewhat unfortunate, because e2fsprogs-1.41.3 has:
 	libblkid.so.1 -> libblkid.so.1.0
 	libuuid.so.1 -> libuuid.so.1.2
with the consequence that as long as the older e2fsprogs libraries are not
removed, ldconfig will create a symlink to the older libuuid from e2fsprogs
(I am not sure about the symlink for libblkid).

This problem could safely be avoided if util-linux-ng were to choose at
least libuuid.so.1.2.0 or maybe even better to be absolutely safe
libblkid.so.1.1.0 and libuuid.so.1.3.0.

Regards
Peter
