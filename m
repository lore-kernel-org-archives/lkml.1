Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbYABWe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbYABWe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 17:34:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbYABWeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 17:34:21 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:33305 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbYABWeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 17:34:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=UQVXH7y7Y0PEmmVi+Ehhasv1mYdG2kZE0GZu33A7/HtwCtoE+a12Qy5YhTByJ3mH2CO8+RydcMvp79pN2WoaVjZPFSm1YE8DduDHVlUcrzdN5SlUH2Bc1oGs2YNDu0s4N4aniC8jZnnMbBmTM3kNhEPfvKlvp22ghVtHg2Pcm/o=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: [PATCH 1/3] ide: use MODULE_VERSION()
Date: Wed, 2 Jan 2008 23:45:17 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: Jon Masters <jonathan@jonmasters.org>, Adrian Bunk <bunk@kernel.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200801011840.38757.bzolnier@gmail.com> <1199241156.3300.55.camel@perihelion> <20080102044620.GB10762@auslistsprd01.us.dell.com>
In-Reply-To: <20080102044620.GB10762@auslistsprd01.us.dell.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801022345.17529.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 January 2008, Matt Domsch wrote:
> On Tue, Jan 01, 2008 at 09:32:36PM -0500, Jon Masters wrote:
> > On Tue, 2008-01-01 at 19:33 +0100, Bartlomiej Zolnierkiewicz wrote:
> > 
> > > On the second thought: maybe we will be better off with limiting
> > > MODULE_VERSION() to the device drivers and the IDE core module for now,
> > > and just removing all these private version numbers from host drivers
> > > (with one or two exceptions they are not printed or exported currently,
> > > moreover exceptions are the cases like stale version numbers from 199x)?
> > 
> > Things like checkpatch could help advise people to bump the version
> > number, but it's a bit iffy. Matt D. actually uses the special source
> > version modinfo for DKMS - which is different - but it makes me wonder
> > whether dynamically generating a version based on source SHA1 wouldn't
> > be a better idea in most cases than an outdated hard-coded one.
> 
> We've got that already, it's called 'srcversion', and it's a CRC32

Neat.

> IIRC after some limited parsing to let it ignore whitspace changes and
> comment changes only.  
> 
> $ modinfo dell_rbu | grep version
> version:        3.2
> srcversion:     1D4815D7D6FBEE6612F3C18

Unfortunately 'srcversion' is set only if MODULE_VERSION() is used... :(

Anyway I'm dropping this patch and removing all versions from comments
for now (patch #2 respin in few minutes)...

Thanks,
Bart
