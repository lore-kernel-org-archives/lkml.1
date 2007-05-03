Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbXECMK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbXECMK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 08:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbXECMK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 08:10:27 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:18516 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbXECMK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 08:10:26 -0400
X-IronPort-AV: i="4.14,485,1170651600"; 
   d="scan'208"; a="28960315:sNHT24065818"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: Execute in place
Date: Thu, 3 May 2007 08:12:38 -0400
User-Agent: KMail/1.9.5
Cc: "Phillip Susi" <psusi@cfl.rr.com>,
       "Linux-kernel" <linux-kernel@vger.kernel.org>
References: <4637B751.1080907@cfl.rr.com> <Pine.LNX.4.64.0705021502450.16517@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0705021502450.16517@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705030812.38347.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 03 May 2007 12:10:25.0519 (UTC) FILETIME=[0820FFF0:01C78D7C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2 May 2007 10:04, Hugh Dickins pondered:
> On Tue, 1 May 2007, Phillip Susi wrote:
> > I seem to remember seeing some patches go by at some point that
> > allowed one of the rom type embeded system filesystems to directly
> > execute binaries out of the original rom memory rather than copying
> > them to ram first, then executing from there.  I was wondering if 
> > rootfs or tmpfs support such execute in place today, or if 
> > binaries executed from there have their code segments duplicated
> > in ram?
>
> Only ext2 supports it today: see Documentation/filesystems/xip.txt
>

Depends on if it is a noMMU or MMU platform.

Since noMMU platforms can't re-arrange non-contiguous blocks (which appears in 
a read/write ext2 file system) we need to use a read only romfs which 
applications are guaranteed to be contiguous by design.

I don't think the noMMU case is documented in xip.txt

-Robin
