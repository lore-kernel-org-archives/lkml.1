Return-Path: <linux-kernel-owner+w=401wt.eu-S1759064AbYDBQUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759064AbYDBQUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756955AbYDBQUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:20:11 -0400
Received: from cpsmtpo-eml03.kpnxchange.com ([213.75.38.152]:58090 "EHLO
	cpsmtpo-eml03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756483AbYDBQUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:20:09 -0400
From: Frans Pop <elendil@planet.nl>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: No IDE drivers loaded for Toshiba Satellite 320 CDS
Date: Wed, 2 Apr 2008 18:20:03 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
References: <200804021524.27222.elendil@planet.nl> <200804021629.41153.elendil@planet.nl> <20080402154636.GH24237@csclub.uwaterloo.ca>
In-Reply-To: <20080402154636.GH24237@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804021820.04610.elendil@planet.nl>
X-OriginalArrivalTime: 02 Apr 2008 16:20:06.0790 (UTC) FILETIME=[6A0BCA60:01C894DD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 April 2008, Lennart Sorensen wrote:
> I am sure the debian installer used to always load ide-generic after
> trying everything else.  There was probably a reason for that.  You
> never have been able to detect isa devices releably (even after pnp was
> invented).

Well, what the installer used to do for Sarge and Etch was basically to load 
_all_ drivers (including ide-generic) manually by default, which is totally 
useless as most devices are perfectly autodetected nowadays. It also wastes 
memory as you'd end up having a lot of unused drivers in memory.

Post-etch we decided to change that and currently drivers are only loaded if 
autodetected (with some exceptions, such as for sparc sbus and hppa bus). 
We were aware that this could cause some regressions, but so far this is the 
first real report.

Another change in Debian since Etch is that initramfs-tools no longer loads 
ide-generic by default, which IMO is also a good thing. We can easily make 
it load ide-generic when needed, but for that again we first have to know 
that it _is_ needed.

> > But to have the installer itself automatically load ide-generic for the
> > user, we'd still have to somehow recognize that we need the driver.
> > Any ideas/suggestions what to look for?
>
> If you can't see any other disks, load it.

Yes, that could be one way to implement it: load it and then check if that 
added any devices.

> Heck load it last no matter 
> what since any supported IDE ports should have already had their driver
> loaded, so worst case it does nothing in which case the autoclean of
> unneeded kernel modules could remove it again, and best case it finds an
> old isa/vlb style IDE controller on the standard port numbers and works
> with it.

That would still leave us with the problem of not knowing whether it needs 
to be added for initramfs-tools or not.

If there are no other suggestions, I guess we'll go with a "load and check" 
implementation. Thanks a lot for your input.

Anybody know how other distributions deal with this?

Cheers,
FJP
