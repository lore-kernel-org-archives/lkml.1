Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbXJCArW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbXJCArW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 20:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbXJCArP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 20:47:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60732 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbXJCArO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 20:47:14 -0400
Message-ID: <4702E683.3060907@zytor.com>
Date: Tue, 02 Oct 2007 17:46:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Vivek Goyal <vgoyal@in.ibm.com>, lguest <lguest@ozlabs.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 0/5] Boot protocol changes
References: <1191368052.17826.40.camel@localhost.localdomain> <4702D867.2060100@goop.org> <4702D9E2.6020407@zytor.com> <4702DAB5.6090003@goop.org> <4702E5C0.5040606@zytor.com>
In-Reply-To: <4702E5C0.5040606@zytor.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
>  
> No, not at all.
> 
> I'm proposing that the existing bzImage format be retained, but that the 
> payload of the decompressor (already a gzip file) simply be vmlinux.gz 
> -- i.e. a gzip compressed ELF file, notes and all.  A pointer in the 
> header will point to the offset of the payload (this is new, obviously.)
> 
> The decompression stub is adjusted to expect an ELF image, instead of a 
> raw binary.
> 
> Existing bootloaders (16- or 32-bit) simply load the bzImage the way 
> they do now; new bootloaders have the option of accessing the vmlinux.gz 
> directly if they either want to load it themselves or want to examine 
> the notes.
> 

Slight correction: it does, of course, break loaders which root through 
the bzImage for a gzip header and decode that themselves and place in 
memory.  These loaders are pretty broken, though; they can't deal with 
the fact that the physical address of the kernel is configurable, for 
one thing.

	-hpa
