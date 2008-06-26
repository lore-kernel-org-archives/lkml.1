Return-Path: <linux-kernel-owner+w=401wt.eu-S1760448AbYFZSEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760448AbYFZSEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbYFZSE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:04:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52963 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbYFZSE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:04:27 -0400
Message-ID: <4863D87F.5060103@zytor.com>
Date: Thu, 26 Jun 2008 10:57:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Adrian Bunk <bunk@kernel.org>, monstr@seznam.cz,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linuxppc-dev@ozlabs.org,
       vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 48/60] microblaze_v4: headers simple files - empty or
 redirect to asm-generic
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz> <200806261735.12738.arnd@arndb.de> <20080626162118.GG22025@cs181140183.pp.htv.fi> <200806261838.33787.arnd@arndb.de>
In-Reply-To: <200806261838.33787.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Thursday 26 June 2008, Adrian Bunk wrote:
>> The comment could be nuked (as well as the #ifdef __KERNEL__), but for 
>> the one #define an asm-generic header would IMHO be overkill.
> 
> I agree that it doesn't technically make sense to have a one-line
> asm-generic header, but I like the idea of reducing the number of
> asm/*.h files that actually contain anything other that
> #include <asm-generic/$FILE.h>, mostly for documentation purposes.
> 
> If we can eventually agree on a way to get rid of the requirement
> for explicit redirection, we can remove a larger number of source
> files completely.
> 

The sanest way to do that would probably be something along the lines of:

-> Change include/asm-xxx to arch/xxx/include/asm
-> Create arch/generic
-> Make sure arch/xxx/include/asm and arch/generic/include/asm are both 
in the include path, in that order.

That would also get rid of the symlink.

On the other hand, the redirection isn't all that bad.

	-hpa
