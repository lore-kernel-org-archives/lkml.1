Return-Path: <linux-kernel-owner+w=401wt.eu-S933855AbXEHSqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933855AbXEHSqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 14:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbXEHSqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 14:46:05 -0400
Received: from terminus.zytor.com ([192.83.249.54]:53760 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbXEHSqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 14:46:04 -0400
Message-ID: <4640C55B.6030908@zytor.com>
Date: Tue, 08 May 2007 11:45:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@mailshack.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make bootsector stub 16-bit-only (i386)
References: <20070505104452.GA30944@mailshack.com> <20070508032817.e4734798.akpm@linux-foundation.org> <20070508183232.GA13225@mailshack.com>
In-Reply-To: <20070508183232.GA13225@mailshack.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum wrote:
> 
> Oh! A padding hole in a struct! That could be a problem. If the freeze
> is after decompression, could you test if this makes it work again?
> 

The correct fix is to apply __attribute__((packed)) to this structure.
Of course, changing the boot sector will cause different random values
to be poked into this field...

I actually caught this during my setup code rewrite, but I forgot that
in the old setup code the parameter structure overlays the boot sector
(it doesn't in my code -- it starts out with nice clean zero-filled memory.)

	-hpa
