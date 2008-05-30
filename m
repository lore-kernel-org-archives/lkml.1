Return-Path: <linux-kernel-owner+w=401wt.eu-S1753687AbYE3NsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbYE3NsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 09:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbYE3Nr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 09:47:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbYE3Nr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 09:47:58 -0400
Date: Fri, 30 May 2008 10:47:15 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       James.Bottomley@HansenPartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2008-discuss] RFC: Moving firmware blobs out of the
	kernel.
Message-ID: <20080530134715.GC5476@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Arjan van de Ven <arjan@linux.intel.com>,
	James.Bottomley@HansenPartnership.com,
	ksummit-2008-discuss@lists.linux-foundation.org,
	David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
References: <1212077700.26088.83.camel@shinybook.infradead.org> <20080529164745.GA21763@kroah.com> <483F1232.4010003@linux.intel.com> <20080529.140919.160813310.davem@davemloft.net> <483F1C17.8040207@linux.intel.com> <1212102258.20303.6.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212102258.20303.6.camel@shinybook.infradead.org>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, May 30, 2008 at 02:04:18AM +0300, David Woodhouse escreveu:
> It's not as if it's hard to set CONFIG_BUILTIN_FIRMWARE_DIR to point to
> your checkout of the linux-firmware repository, and build your kernel
> with _whatever_ firmware you choose. You end up with _more_ choice, not
> less.
> 
> And on the rare occasion that we really do have an incompatible change
> of firmware/kernel interaction from one kernel to the next, it really
> isn't difficult to add a version number to the name of the firmware
> file, and ship both old and new firmwares in the firmware tree for a
> while. That's a bogus argument, even if people _do_ manage to come up
> with a better example for it, where their firmware has actually changed
> in the last couple of years.

While updating the bnx2 driver on a 2.6.24.7 based rpm and after reading
some of your messages...

commit df7f1ed6b85b936a4dd341c48e30aa207697997c
Author: Michael Chan <mchan@broadcom.com>
Date:   Tue Jan 29 21:38:06 2008 -0800

    [BNX2]: Update firmware.
    
    Update firmware to support programmable flow control.
    
    Signed-off-by: Michael Chan <mchan@broadcom.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

After this bnx2.c would be updated to have a:

MODULE_FIRMWARE_DEFAULT("df7f1ed6b85b936a4dd341c48e30aa207697997c");

to be obtained from firmware.git, and if some chip revisions needed
something different we could have a MODULE_FIRMWARE_PCI(vendor, product,
older-git-object) or something along these lines.

Some drivers could well prefer a more loose keying scheme, like
"foo-firmware-v2" and get the latest version of this from firmware.git.

- Arnaldo
