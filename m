Return-Path: <linux-kernel-owner+w=401wt.eu-S1760369AbYB1VrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760369AbYB1VrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 16:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbYB1VrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 16:47:04 -0500
Received: from pat.uio.no ([129.240.10.15]:53465 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719AbYB1VrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 16:47:03 -0500
Subject: Re: [regression] nfs4: 30 second delay during umount of remote fs
	on system shutdown
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Frans Pop <elendil@planet.nl>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200802281829.16343.elendil@planet.nl>
References: <200802281829.16343.elendil@planet.nl>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 13:46:58 -0800
Message-Id: <1204235218.7109.13.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: 7978143C8FEF9CBBC9EBA6346770BF4E0A9A5260
X-UiO-SR-test: 31BFDA32ED3E931A22859D610BCC67497C15AD5B
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 585 total 7142340 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 18:29 +0100, Frans Pop wrote:

> I have verified that portmap is also not running during S31umountnfs.sh with 
> 2.6.24, so apparently there has been a change in the kernel that has made 
> umount look for portmap and cause the 30 second delay if it is not running.

You are probably seeing the effect of lockd going down: it always
attempts to unregister from the portmapper (and no, this is _not_ new
behaviour).

If debian is killing the portmapper while lockd is still up, then that
is a definite debian bug...

Trond

