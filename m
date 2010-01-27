Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646Ab0A0Mar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab0A0Mar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 07:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198Ab0A0Maq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 07:30:46 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42010 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab0A0Map (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 07:30:45 -0500
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: file/extent checksums for dedup/sync...
From: Andi Kleen <andi@firstfloor.org>
References: <6278d2221001270410k1493582fvccdf23bed14cc0ff@mail.gmail.com>
Date: Wed, 27 Jan 2010 13:30:43 +0100
In-Reply-To: <6278d2221001270410k1493582fvccdf23bed14cc0ff@mail.gmail.com> (Daniel J. Blueman's message of "Wed, 27 Jan 2010 12:10:50 +0000")
Message-ID: <87pr4venm4.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel J Blueman <daniel.blueman@gmail.com> writes:

> For purposes of data deduplication and data synchronisation, it would
> be a powerful tool to expose file data checksums.
>
> Since eg BTRFS uses the crc32c algorithm [1], it's possible to compute
> the file's overall CRC from the accumulation of the CRCs from all it's
> extents' CRCs.
>
> For now, exposing this via an IOCTL may be sufficient, though any
> ideas for introducing it in a more standard way? (it's a pity that
> when stat64 was introduced, reserved fields weren't added)

The problem of doing it in any "standard way" is that it would
hard code the way the file system does checksums in the applications.
So the file system could never change it without breaking
user space.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
