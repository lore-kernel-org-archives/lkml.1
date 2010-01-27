Return-Path: <linux-kernel-owner+w=401wt.eu-S1753806Ab0A0UQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab0A0UQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:16:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540Ab0A0UQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:16:12 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:46733 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab0A0UQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:16:08 -0500
Date: Wed, 27 Jan 2010 15:15:50 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux BTRFS <linux-btrfs@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: file/extent checksums for dedup/sync...
Message-ID: <20100127201550.GW2770@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Daniel J Blueman <daniel.blueman@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <6278d2221001270410k1493582fvccdf23bed14cc0ff@mail.gmail.com>
 <87pr4venm4.fsf@basil.nowhere.org>
 <6278d2221001270523r13ab8973v927c8b60da181c9c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6278d2221001270523r13ab8973v927c8b60da181c9c@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B609EFA.005B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 01:23:28PM +0000, Daniel J Blueman wrote:
> On Wed, Jan 27, 2010 at 12:30 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > Daniel J Blueman <daniel.blueman@gmail.com> writes:
> >
> >> For purposes of data deduplication and data synchronisation, it would
> >> be a powerful tool to expose file data checksums.
> >>
> >> Since eg BTRFS uses the crc32c algorithm [1], it's possible to compute
> >> the file's overall CRC from the accumulation of the CRCs from all it's
> >> extents' CRCs.
> >>
> >> For now, exposing this via an IOCTL may be sufficient, though any
> >> ideas for introducing it in a more standard way? (it's a pity that
> >> when stat64 was introduced, reserved fields weren't added)
> >
> > The problem of doing it in any "standard way" is that it would
> > hard code the way the file system does checksums in the applications.
> > So the file system could never change it without breaking
> > user space.

At the end of the day the checksums are also hard coded on disk.  We
can't add a new way without continuing to support the old one.

> 
> I guess the filesystem would need to express this in the resulting
> data-structure, eg:
>  - type 1 corresponds to using the crc32c algorithm with starting seed
> N and accumulating ascending over data extents, padding with modulus
> remainder or sparse holes with 0
>  - type 2 etc

Yes, if they were exported to userland we'd need to export version info.

> 
> The next question, is does filesystem (eg BTRFS) compression come
> before or after checksumming?

The checksums are based on what is on disk, so they are done on the
compressed data.

-chris

