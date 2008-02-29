Return-Path: <linux-kernel-owner+w=401wt.eu-S1759373AbYB2BK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373AbYB2BK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 20:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763745AbYB2BDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 20:03:16 -0500
Received: from hpsmtp-eml11.kpnxchange.com ([213.75.38.111]:11189 "EHLO
	hpsmtp-eml11.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762625AbYB2BDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 20:03:14 -0500
From: Frans Pop <elendil@planet.nl>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: [regression] nfs4: 30 second delay during umount of remote fs on system shutdown
Date: Fri, 29 Feb 2008 02:03:05 +0100
User-Agent: KMail/1.9.7
References: <200802281829.16343.elendil@planet.nl> <1204235218.7109.13.camel@heimdal.trondhjem.org>
In-Reply-To: <1204235218.7109.13.camel@heimdal.trondhjem.org>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802290203.06241.elendil@planet.nl>
X-OriginalArrivalTime: 29 Feb 2008 01:03:08.0062 (UTC) FILETIME=[D8B263E0:01C87A6E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 February 2008, Trond Myklebust wrote:
> On Thu, 2008-02-28 at 18:29 +0100, Frans Pop wrote:
> > I have verified that portmap is also not running during S31umountnfs.sh
> > with 2.6.24, so apparently there has been a change in the kernel that
> > has made umount look for portmap and cause the 30 second delay if it is
> > not running.
>
> You are probably seeing the effect of lockd going down: it always
> attempts to unregister from the portmapper (and no, this is _not_ new
> behaviour).

It is _very much_ new behavior because as soon as I boot (and shut down) 
with a 2.6.24 kernel the problem completely disappears. Userland is *100% 
identical* between my tests.

> If debian is killing the portmapper while lockd is still up, then that
> is a definite debian bug...

I have no idea about that. AFAICT lockd is not even running (at least, 
there's no process named lockd, even when the system is running normally.
Isn't lockd an nfs3 thing? I'm using nfs4 here.

Cheers,
FJP
