Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbYABE4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbYABE4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 23:56:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbYABEz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 23:55:59 -0500
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:9909 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbYABEz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 23:55:58 -0500
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jan 2008 23:55:58 EST
X-IronPort-AV: E=Sophos;i="4.24,232,1196661600"; 
   d="scan'208";a="512095033"
Date: Tue, 1 Jan 2008 22:46:20 -0600
From: Matt Domsch <Matt_Domsch@dell.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Adrian Bunk <bunk@kernel.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ide: use MODULE_VERSION()
Message-ID: <20080102044620.GB10762@auslistsprd01.us.dell.com>
References: <200801011840.38757.bzolnier@gmail.com> <20080101175333.GA27566@does.not.exist> <200801011933.43930.bzolnier@gmail.com> <1199241156.3300.55.camel@perihelion>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199241156.3300.55.camel@perihelion>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 09:32:36PM -0500, Jon Masters wrote:
> On Tue, 2008-01-01 at 19:33 +0100, Bartlomiej Zolnierkiewicz wrote:
> 
> > On the second thought: maybe we will be better off with limiting
> > MODULE_VERSION() to the device drivers and the IDE core module for now,
> > and just removing all these private version numbers from host drivers
> > (with one or two exceptions they are not printed or exported currently,
> > moreover exceptions are the cases like stale version numbers from 199x)?
> 
> Things like checkpatch could help advise people to bump the version
> number, but it's a bit iffy. Matt D. actually uses the special source
> version modinfo for DKMS - which is different - but it makes me wonder
> whether dynamically generating a version based on source SHA1 wouldn't
> be a better idea in most cases than an outdated hard-coded one.

We've got that already, it's called 'srcversion', and it's a CRC32
IIRC after some limited parsing to let it ignore whitspace changes and
comment changes only.  

$ modinfo dell_rbu | grep version
version:        3.2
srcversion:     1D4815D7D6FBEE6612F3C18

DKMS uses the srcversion if present recognize an exact match.
srcversions can't be tested for anything <> though, only =.

DKMS also uses the version field as supplied by MODULE_VERSION() to
try to determine older-vs-newer modules.  On occasion we've had to
release updated "fixed" kernel modules, in which case we bump the
value in MODULE_VERSION() slightly (typically append .1 or something
similar) so the "fixed" module version compares higher.  Such version
fields aren't generally used with stock kernel.org kernels (where
users can be expected to upgrade to a later stock kernel), but for
users of a distro kernel where we need to fix a module without forcing
the user to upgrade the whole kernel.

-Matt

-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
