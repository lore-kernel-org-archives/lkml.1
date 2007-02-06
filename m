Return-Path: <linux-kernel-owner+w=401wt.eu-S965534AbXBFVtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965534AbXBFVtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965540AbXBFVtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:49:36 -0500
Received: from terminus.zytor.com ([192.83.249.54]:55870 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965534AbXBFVtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:49:35 -0500
Message-ID: <45C8F7E6.6060009@zytor.com>
Date: Tue, 06 Feb 2007 13:49:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: Markus Rechberger <markus.rechberger@amd.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch] x86-64 ext2/ext3 datestamp problem
References: <45C8F419.5040103@amd.com>
In-Reply-To: <45C8F419.5040103@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Rechberger wrote:
> Hi,
> 
> there is an issue with ext2/ext3 date stamps, if someone creates a file
> with a timestamp between 1902 and 1970(epoch 0) it will overflow and
> result in a higher date than 2038.
> 
> $ touch --date "1905-01-01" test
> $ ls -lah test
> -rw-r--r-- 1 root root 0 Jan  1  1905 test (this is a cached value here)
> (remount the partition/clear the cache)
> $ ls -lah test
> -rw-r--r-- 1 root root 0 Feb  6  2041 test
> 
> 10000101101111001100011001110000 .. -2051226000 (1905)
> 10000101101111001100011001110000 .. 2243741296 (2041)
> 
> this was tested against linus git tree
> 

I believe the timestamp fields in ext2/ext3 are defined as unsigned.

	-hpa
