Return-Path: <linux-kernel-owner+w=401wt.eu-S1760077AbXHXRA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077AbXHXRA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 13:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755399AbXHXRAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 13:00:14 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:53660 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbXHXRAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 13:00:13 -0400
Date: Fri, 24 Aug 2007 13:00:06 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: sparclinux@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       parisc-linux@parisc-linux.org
Subject: Re: errno codes intertwined
Message-ID: <20070824170006.GA3543@filer.fsl.cs.sunysb.edu>
References: <Pine.LNX.4.64.0708241815540.28540@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708241815540.28540@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.16 (2007-07-16)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 06:24:48PM +0200, Jan Engelhardt wrote:
...
> If a file does not have the requested attribute, the syscall will 
> produce ENODATA. On x86_64, that is mapped to the value 61. Back on the 
> sparc side, 61 is mapped to ECONNREFUSED, and that gives odd errors 
> when ls tries to query xattrs:
 
I'd think that passing the raw error code is a bad idea, and that you
probably want to have your own set of codes that you use in the trasport and
map value to/from the host's errno values.

> the values are exactly swapped (mips is another oddball not portrayed 
> here). Since these header files propagate into /usr/include, this 
> affects userspace programs too.

Yep, and it kind of sucks.

> So I'm just asking: can I rely on the same errno across Linuxes?

I wouldn't - Linux on different different architectures seems to have
different errno codes.

> And should the errno values be fixed up?

It would break userspace :-/

Josef 'Jeff' Sipek.

-- 
*NOTE: This message is ROT-13 encrypted twice for extra protection*
