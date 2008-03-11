Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbYCKGWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbYCKGWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 02:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750929AbYCKGWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 02:22:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750699AbYCKGW3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 02:22:29 -0400
Date: Mon, 10 Mar 2008 23:20:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Avi Kivity <avi@qumranet.com>,
       Sam Ravnborg <sam@ravnborg.org>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       David Howells <dhowells@redhat.com>, linux-arch@vger.kernel.org,
       mm-commits@vger.kernel.org
Subject: Re: [PATCH] kvm: provide kvm.h for all architecture: fixes
 headers_install
Message-Id: <20080310232039.d2a34f5a.akpm@linux-foundation.org>
In-Reply-To: <200803101411.04175.borntraeger@de.ibm.com>
References: <200803071326.06682.borntraeger@de.ibm.com>
	<1204933418.2495.14.camel@shinybook.infradead.org>
	<200803101411.04175.borntraeger@de.ibm.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008 14:11:04 +0100 Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> [PATCH v2] kvm: provide kvm.h for all architecture: fixes headers_install
> 
> Currently include/linux/kvm.h is not considered by make headers_install, 
> because Kbuild cannot handle " unifdef-$(CONFIG_FOO) += foo.h. 
> This problem was introduced by 040922c04cf2c8ac70be2e88a8a9614ecdb41d2e, 
> which makes this an 2.6.25 regression.
> 
> One way of solving the issue is to enhance Kbuild, but Avi Kivity and David
> Woodhouse conviced me, that changing headers_install is not the way to go. 
> This patch changes the definition for linux/kvm.h to unifdef-y.
> 
> If  unifdef-y is used for linux/kvm.h "make headers_check" will fail on all
> architectures without asm/kvm.h. Therefore, this patch also provides 
> asm/kvm.h on all architectures.
> 
> Changes since v1:
> o use asm-generic/Kbuild.asm (Arnd Bergmann)
> o fix comment in asm-frv (David Howells)

err, this doesn't work.

alpha and m68k (at least) fail make headers_check

/usr/src/devel/usr/include/linux/kvm.h requires asm/kvm.h, which does not exist in exported headers
