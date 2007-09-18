Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbXIRSqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbXIRSqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 14:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbXIRSqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 14:46:44 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:4582 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbXIRSqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 14:46:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lKxTixadYJiFDQJnYMPbOFSEWG8sANrs8pCTUgEKYIVv+bMeFfgE0fqA5hv8rDQSPaTlUIplmSCVNMyUpASB4pu3J0+uteLhvtHK+X9g1DJb8UJDwgzLGQ1kHkQAZ0vVfqk4maHXJ8N/n/UnxeZeYyVeIYFQlNh+BH3JnCx4djY=
Message-ID: <43e72e890709181146s604e0f9fl8b0c16627469c77f@mail.gmail.com>
Date: Tue, 18 Sep 2007 14:46:40 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Clarify pci_iomap() usage for MMIO-only devices
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070918113401.6a8a737f@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <43e72e890709171322x76ab6b70xd29bf97e3643c553@mail.gmail.com>
	 <20070918113401.6a8a737f@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/18/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Mon, 17 Sep 2007 16:22:07 -0400
> "Luis R. Rodriguez" <mcgrof@gmail.com> wrote:
>
> > This patch updates the pci_iomap() kernel-doc to make it clarify the
> > case when read*()/write*() can be called over ioread*/iowrite*(). When
> > driver writers read this documenation sometimes it is assumed you just
> > *need* to use ioread*()/iorwrite*(). We have an exception so lets just
> > clarify this is not true for the exception.
> >
> >  lib/iomap.c |   11 ++++++++---
> >  1 files changed, 8 insertions(+), 3 deletions(-)
> >
> > Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
>
> Reviewed-by: Alan Cox <alan@redhat.com>
>
> Although I would say s/recommended/required/

Alright, here is the same patch inline with s/recommended/required/ language:

Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>

  Luis

---
 lib/iomap.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/lib/iomap.c b/lib/iomap.c
index 864f2ec..33651f8 100644
--- a/lib/iomap.c
+++ b/lib/iomap.c
@@ -247,9 +247,14 @@ EXPORT_SYMBOL(ioport_unmap);
  * @maxlen: length of the memory to map
  *
  * Using this function you will get a __iomem address to your device BAR.
- * You can access it using ioread*() and iowrite*(). These functions hide
- * the details if this is a MMIO or PIO address space and will just do what
- * you expect from them in the correct way.
+ * If you use pci_iomap() it is recommended you use ioread*() and
iowrite*(). If
+ * your device is MMIO-only and as long as future architectures don't break the
+ * assumption that pcio_iomap()-returned cookie can be used by read*()/write*()
+ * then you can use read*()/write*() instead. The ioread*() and iowrite*()
+ * functions hide the details if this is a MMIO or PIO address space and will
+ * just do what you expect from them in the correct way. Drivers for MMIO-only
+ * devices would use this only to save themselves from having to call
+ * &pci_resource_start().
  *
  * @maxlen specifies the maximum length to map. If you want to get access to
  * the complete BAR without checking for its length first, pass %0 here.
