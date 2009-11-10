Return-Path: <linux-kernel-owner+w=401wt.eu-S1758436AbZKJVzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436AbZKJVzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 16:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758420AbZKJVzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 16:55:41 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:49676 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758407AbZKJVzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:55:40 -0500
Message-ID: <4AF9E107.8050605@nortel.com>
Date: Tue, 10 Nov 2009 15:54:15 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: Trond Myklebust <trond.myklebust@fys.uio.no>, netdev@vger.kernel.org,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: sunrpc port allocation and IANA reserved list
References: <4AF9A63B.6010101@nortel.com>	 <1257875623.2834.19.camel@achroite.uk.solarflarecom.com>	 <4AF9B2CF.6050305@nortel.com>	 <1257884799.3044.7.camel@heimdal.trondhjem.org>	 <4AF9D5D1.9040501@nortel.com> <1257888720.2834.30.camel@achroite.uk.solarflarecom.com>
In-Reply-To: <1257888720.2834.30.camel@achroite.uk.solarflarecom.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2009 21:55:36.0826 (UTC) FILETIME=[88F6C5A0:01CA6250]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2009 03:32 PM, Ben Hutchings wrote:

> I'm sure we could afford 128 bytes for a blacklist of privileged ports.
> However, the problem is that there is no API for userland to request
> 'any free privileged port' - it has to just try binding to different
> ports until it finds one available.  This means that the kernel can't
> tell whether a process is trying to allocate a specifically assigned
> port or whether the blacklist should be applied.

That's unfortunate.  Maybe a bindresvport syscall would make sense, but
that's starting to get bloated.  At least for userspace apps netstat
will show who the owner is and it might be possible to clean it up
without rebooting.

For the ports allocated in the kernel via xs_get_random_port() and
xprt_bindresvport() it would be fairly easy to check a blacklist.

Interestingly, the current kernel range starts at 665 because IPMI is
known to use 664.  The current glibc range to be tried in bindresvport()
starts at 600, which seems to be a bug waiting to happen.

Chris
