Return-Path: <linux-kernel-owner+w=401wt.eu-S1754555AbZHFWmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbZHFWmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 18:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbZHFWmk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 18:42:40 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60211 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbZHFWmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 18:42:39 -0400
Date: Thu, 6 Aug 2009 23:40:55 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
Cc: sam@ravnborg.org, hpa@zytor.com, alain@knaff.lu,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 4/6] Add support for LZO-compressed kernels for ARM
Message-ID: <20090806224055.GH31579@n2100.arm.linux.org.uk>
References: <20090731093107.GA29704@merkur.ravnborg.org> <1249311501-23102-1-git-send-email-albin.tonnerre@free-electrons.com> <1249311501-23102-2-git-send-email-albin.tonnerre@free-electrons.com> <1249311501-23102-3-git-send-email-albin.tonnerre@free-electrons.com> <1249311501-23102-4-git-send-email-albin.tonnerre@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249311501-23102-4-git-send-email-albin.tonnerre@free-electrons.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 04:58:19PM +0200, Albin Tonnerre wrote:
> This is the second part of patch. This part includes:
>  - changes to ach/arch/boot/Makefile to make it easier to add new
>    compression types
>  - new piggy.lzo.S necessary for lzo compression
>  - changes in arch/arm/boot/compressed/misc.c to allow the use of lzo or
>    gzip, depending on the config
>  - Kconfig support

FYI, with these patches applied and selecting GZIP method, I get
linker errors.  I've been unable to track down what's going on, but
it appears to be a libgcc issue.

In spite of the decompressor being built as an EABI object, gcc seems
to be issuing calls to __umodsi3, which isn't in the EABI libgcc
(they're called something different - don't ask.)

So I think these patches need further testing and evaluation on ARM
before they can be merged.  Moreover, I'd like to see some comparisons
between the _current_ gzip method, the new gzip method and the lzo
method on ARM.

I was going to get those numbers, but the platform I was going to run
the tests on has died on me today.
