Return-Path: <linux-kernel-owner+w=401wt.eu-S1758459AbZCBBLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459AbZCBBLj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 20:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755791AbZCBBLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 20:11:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53461 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755792AbZCBBL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 20:11:29 -0500
Message-ID: <49AB316E.4000009@zytor.com>
Date: Sun, 01 Mar 2009 17:07:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: brk patches..
References: <1235785882-17580-1-git-send-email-jeremy@goop.org>	 <1235785882-17580-4-git-send-email-jeremy@goop.org>	 <86802c440902272302n3787b2bex3741b46a372a19b0@mail.gmail.com>	 <49A8E235.6010900@goop.org> <20090228071534.GB9351@elte.hu>	 <49A8EA1A.50802@kernel.org> <49A8ED3D.1060704@kernel.org>	 <49A8F319.3030802@goop.org> <86802c440902281240i11423a95l98e330768ac6ca18@mail.gmail.com> <49AB1FE6.8030300@goop.org> <49AB3031.4020500@kernel.org>
In-Reply-To: <49AB3031.4020500@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> hope later boot loader could check vmlinux size in bzImage (according uncompressed size)
> and find good position in RAM for bzImage.
> 
> we should find good position for brk with find_e820_area().
> 

If the brk is bounded-size on the same order or smaller as the kernel,
we should just mark it as an unallocated (bss) section in the ELF image
and be done with it... there really is no point in trying to be smarter
(we'd be subject to failures to load the kernel proper.)  If the brk is
significantly bigger, then yes, we need to be smarter.  However, that is
not my current understanding of the requirements.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

