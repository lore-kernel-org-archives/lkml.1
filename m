Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbYGPFyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbYGPFyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 01:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbYGPFy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 01:54:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34141 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbYGPFy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 01:54:28 -0400
Subject: Re: Prosaic firmware issues
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Frans Pop <elendil@planet.nl>, david@lang.hm,
       Marcel Holtmann <marcel@holtmann.org>, arjan@infradead.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0807151843240.2835@woody.linux-foundation.org>
References: <1216077806.27455.85.camel@shinybook.infradead.org>
	 <alpine.DEB.1.10.0807151503310.16109@asgard.lang.hm>
	 <alpine.LFD.1.10.0807151631260.2867@woody.linux-foundation.org>
	 <200807160222.40705.elendil@planet.nl>
	 <alpine.LFD.1.10.0807151726520.2867@woody.linux-foundation.org>
	 <487D441B.5010908@garzik.org>
	 <20080716011140.GA30967@martell.zuzino.mipt.ru>
	 <alpine.LFD.1.10.0807151843240.2835@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 22:54:04 -0700
Message-Id: <1216187644.30898.7.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 18:45 -0700, Linus Torvalds wrote:
> 
> On Wed, 16 Jul 2008, Alexey Dobriyan wrote:
> >
> > Could somebody from firmware people fix boring stuff, please:
> > 
> > 1) after allyesconfig build, git-status show plenty of crap:
> 
> Something like the appended, perhaps?
> 
> (I'm not going to commit it, I want some firmware person to double-check 
> it).

Generally sane, but wants a few more things added.

> > 2) after "make mrproper" after allyesconfig, some files aren't removed,
> >    use "git-ls-files -o" to see them.
> 
> Ok, that needs some Makefile magic. git magic I can do.

Ah, that's caused by a stray := where there should be a +=, so the
firmware files listed before that get dropped from the list of files to
be cleaned. 

Alexey, thanks for the report. Please could you verify that this fixes
it for you?

----
Subject: Fix 'make clean' and .gitignore for firmware/ directory.

Provide a .gitignore file, and fix a typo which prevented some of the
generated binary files from being removed on 'make clean'.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

diff --git a/firmware/.gitignore b/firmware/.gitignore
new file mode 100644
index 0000000..d9c6901
--- /dev/null
+++ b/firmware/.gitignore
@@ -0,0 +1,6 @@
+*.gen.S
+*.fw
+*.bin
+*.csp
+*.dsp
+ihex2fw
diff --git a/firmware/Makefile b/firmware/Makefile
index 981bd52..55ca321 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -73,7 +73,7 @@ fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA28X) += keyspan/usa28x.fw
 fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA49W) += keyspan/usa49w.fw
 fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA49WLC) += keyspan/usa49wlc.fw
 else
-fw-shipped- := keyspan/mpr.fw keyspan/usa18x.fw keyspan/usa19.fw	\
+fw-shipped- += keyspan/mpr.fw keyspan/usa18x.fw keyspan/usa19.fw	\
 	keyspan/usa19qi.fw keyspan/usa19qw.fw keyspan/usa19w.fw		\
 	keyspan/usa28.fw keyspan/usa28xa.fw keyspan/usa28xb.fw		\
 	keyspan/usa28x.fw keyspan/usa49w.fw keyspan/usa49wlc.fw


-- 
dwmw2

