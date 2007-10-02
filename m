Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbXJBX4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbXJBX4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 19:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbXJBX4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 19:56:38 -0400
Received: from gw.goop.org ([64.81.55.164]:42404 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbXJBX4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 19:56:37 -0400
Message-ID: <4702DAB5.6090003@goop.org>
Date: Tue, 02 Oct 2007 16:56:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Vivek Goyal <vgoyal@in.ibm.com>, lguest <lguest@ozlabs.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 0/5] Boot protocol changes
References: <1191368052.17826.40.camel@localhost.localdomain> <4702D867.2060100@goop.org> <4702D9E2.6020407@zytor.com>
In-Reply-To: <4702D9E2.6020407@zytor.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
>> This series looks like a good start for Xen, but we still need to work
>> out where to stash the metadata which normally lives in ELF notes. 
>> Using ELF is convenient for Xen because it lets a large chunk of domain
>> builder code be reused; on the other hand, loading a plain bzImage is
>> pretty simple, so maybe it isn't such a big deal.
>>
>> HPA, Eric: if we don't go the "embed ELF" path, where's a good
>> backwards-compatible place to stash the note data?  If we do go with
>> "embed ELF", how should we go about doing it?  Arrange to put the ELF
>> headers before the 1M mark?
>>
>
> This sounds like another good reason to do the ELF image as the
> postcompression image.  The interface to the embedded compression
> routine is then unchanged, and we get the "full vmlinux" with any
> notes that belongs there.
>
> I'll try to get an implementation of that done -- it really shouldn't
> be very hard.

Please explain what you're proposing again, because my memory of your
plan from last time wouldn't help in this case.  Are you proposing that
the bzImage contains compressed data that its expecting the bootloader
to decompress?  Won't that completely break backwards compatibility?  If
we don't care about backwards compatibility with old bootloaders, then
it doesn't matter what we do one way or the other.

    J
