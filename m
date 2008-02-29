Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbYB2Ezb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbYB2Ezb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 23:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbYB2EzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 23:55:22 -0500
Received: from pat.uio.no ([129.240.10.15]:40380 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004AbYB2EzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 23:55:21 -0500
Subject: Re: [regression] nfs4: 30 second delay during umount of remote fs
	on system shutdown
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Frans Pop <elendil@planet.nl>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200802290203.06241.elendil@planet.nl>
References: <200802281829.16343.elendil@planet.nl>
	 <1204235218.7109.13.camel@heimdal.trondhjem.org>
	 <200802290203.06241.elendil@planet.nl>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 20:55:16 -0800
Message-Id: <1204260916.7213.5.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: 47ED2608BEB890C2EF3F0763717D6E667209752A
X-UiO-SR-test: 5D45DE90FDCF72B09467895E12B000C1D4F7FC7A
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 76 total 7144084 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-29 at 02:03 +0100, Frans Pop wrote:
> On Thursday 28 February 2008, Trond Myklebust wrote:
> > On Thu, 2008-02-28 at 18:29 +0100, Frans Pop wrote:
> > > I have verified that portmap is also not running during S31umountnfs.sh
> > > with 2.6.24, so apparently there has been a change in the kernel that
> > > has made umount look for portmap and cause the 30 second delay if it is
> > > not running.
> >
> > You are probably seeing the effect of lockd going down: it always
> > attempts to unregister from the portmapper (and no, this is _not_ new
> > behaviour).
> 
> It is _very much_ new behavior because as soon as I boot (and shut down) 
> with a 2.6.24 kernel the problem completely disappears. Userland is *100% 
> identical* between my tests.

The "new behaviour" is that we fixed a bug whereby the lockd code was
failing to flush signals before attempting the rpc unregister. The sad
fact is that userland appears to have been 100% broken for some time.
The difference is that it was able to get away with it earlier...

> > If debian is killing the portmapper while lockd is still up, then that
> > is a definite debian bug...
> 
> I have no idea about that. AFAICT lockd is not even running (at least, 
> there's no process named lockd, even when the system is running normally.
> Isn't lockd an nfs3 thing? I'm using nfs4 here.

NFSv4 has a delegation recall server to kill. Same difference...

Trond

