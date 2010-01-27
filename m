Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646Ab0A0NXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab0A0NXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 08:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146Ab0A0NXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 08:23:31 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:34774 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab0A0NXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 08:23:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=oOkqxe7imvkR2JOf3v2ugEYD8s4BzC2C+83Ykz3xtuksJOER09GGoVY2fgEmff3J4D
         iQl6ehr5pthEBzsDDVLra8KPnIormiGc+YJF5z1HLCXeSXyLtxt0Gdaau0mP1pzMFNWs
         /pQyMft51wof/gfvk6JaBAD4/s3bExQGgzSHs=
MIME-Version: 1.0
In-Reply-To: <87pr4venm4.fsf@basil.nowhere.org>
References: <6278d2221001270410k1493582fvccdf23bed14cc0ff@mail.gmail.com>
	 <87pr4venm4.fsf@basil.nowhere.org>
Date: Wed, 27 Jan 2010 13:23:28 +0000
Message-ID: <6278d2221001270523r13ab8973v927c8b60da181c9c@mail.gmail.com>
Subject: Re: file/extent checksums for dedup/sync...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Andi Kleen <andi@firstfloor.org>,
       Linux BTRFS <linux-btrfs@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 12:30 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Daniel J Blueman <daniel.blueman@gmail.com> writes:
>
>> For purposes of data deduplication and data synchronisation, it would
>> be a powerful tool to expose file data checksums.
>>
>> Since eg BTRFS uses the crc32c algorithm [1], it's possible to compute
>> the file's overall CRC from the accumulation of the CRCs from all it's
>> extents' CRCs.
>>
>> For now, exposing this via an IOCTL may be sufficient, though any
>> ideas for introducing it in a more standard way? (it's a pity that
>> when stat64 was introduced, reserved fields weren't added)
>
> The problem of doing it in any "standard way" is that it would
> hard code the way the file system does checksums in the applications.
> So the file system could never change it without breaking
> user space.

I guess the filesystem would need to express this in the resulting
data-structure, eg:
 - type 1 corresponds to using the crc32c algorithm with starting seed
N and accumulating ascending over data extents, padding with modulus
remainder or sparse holes with 0
 - type 2 etc

The next question, is does filesystem (eg BTRFS) compression come
before or after checksumming?
-- 
Daniel J Blueman
