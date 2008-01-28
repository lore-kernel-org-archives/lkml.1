Return-Path: <linux-kernel-owner+w=401wt.eu-S1765220AbYA1XZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765220AbYA1XZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763375AbYA1XXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:23:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45375 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765022AbYA1XX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:23:29 -0500
Message-ID: <479E6323.5030200@zytor.com>
Date: Mon, 28 Jan 2008 15:20:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: PATCH/RFC: bzImage payload as compressed ELF file.
References: <1201560133.17053.36.camel@cthulhu.hellion.org.uk>
In-Reply-To: <1201560133.17053.36.camel@cthulhu.hellion.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> 
> What would be the preferred way of allowing bootloaders/domain builders
> to find the compressed payload? Tacking the offset from the end onto the
> end as I have done for the moment seems pretty skanky...
> 

As Jeremy already mentioned, putting a pointer to the compressed ELF 
image in the bzImage header (and bumping the version number to 2.08) is 
the right way to go about it.  The compression format (for now, always 
gzip) can then be identified in the usual way via compression format 
magic number.

As I've previously expressed, I'm much happier with this approach than 
having the compressor portion itself be an ELF image, so I'm happy to 
see this patch.  However, I think it needs to ride a cycle in -mm, so 
although I didn't see any problems from a cursory look I might not get a 
chance to do a detailed review until the merge window is over.

	-hpa
