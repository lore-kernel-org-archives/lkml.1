Return-Path: <linux-kernel-owner+w=401wt.eu-S2993265AbXEBOio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993265AbXEBOio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 10:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993266AbXEBOin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 10:38:43 -0400
Received: from mail.gmx.net ([213.165.64.20]:37356 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S2993265AbXEBOin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 10:38:43 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1+GQRFAxP2GtcAlrUV0x3lP4/lSYKhYD3TMyjcXPD
	a72gnb+xU/CnXx
Date: Wed, 2 May 2007 16:38:39 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Hugh Dickins <hugh@veritas.com>
Cc: Phillip Susi <psusi@cfl.rr.com>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Execute in place
Message-ID: <20070502143839.GA31961@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Hugh Dickins <hugh@veritas.com>, Phillip Susi <psusi@cfl.rr.com>,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <4637B751.1080907@cfl.rr.com> <Pine.LNX.4.64.0705021502450.16517@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0705021502450.16517@blonde.wat.veritas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.05.02 15:04:44 +0100, Hugh Dickins wrote:
> On Tue, 1 May 2007, Phillip Susi wrote:
> > I seem to remember seeing some patches go by at some point that
> > allowed one of the rom type embeded system filesystems to directly
> > execute binaries out of the original rom memory rather than copying
> > them to ram first, then executing from there.  I was wondering if
> > rootfs or tmpfs support such execute in place today, or if binaries
> > executed from there have their code segments duplicated in ram?
> 
> Only ext2 supports it today: see Documentation/filesystems/xip.txt

As I understand it, xip avoids the page cache copy. But tmpfs already
lives in the page cache (or swap), so avoiding that "copy" is
impossible. But I always expected tmpfs to implicitly due its own kind
of xip, i.e. that it doesn't have to store its stuff in the page cache
twice. Are you saying that this isn't true?

According to Documentation/filesystems/xip.txt the ramdisk driver does
something similar, pushing the data into the page cache and discarding
the original data.

thanks,
Björn
