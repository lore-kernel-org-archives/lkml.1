Return-Path: <linux-kernel-owner+w=401wt.eu-S1751466AbZKZSPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbZKZSPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 13:15:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbZKZSPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 13:15:39 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:46515 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbZKZSPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 13:15:38 -0500
Date: Thu, 26 Nov 2009 18:15:54 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: wuzhangjin@gmail.com, Andreas Mohr <andi@lisas.de>,
       linux-kernel@vger.kernel.org
Subject: Re: snd_usb_audio OOPS on MIPSEL - is that the mmap issue?
Message-ID: <20091126181554.GB11737@linux-mips.org>
References: <20091125231211.GA19559@rhlx01.hs-esslingen.de>
 <1259198431.2870.17.camel@falcon.domain.org>
 <s5h7htdodov.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h7htdodov.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 10:09:04AM +0100, Takashi Iwai wrote:

> I guess it won't, because usb audio driver provides its own page
> callback.  It uses vmalloced buffer as the primary buffer, then
> copies to the urb transfer buffer.  So, mmap should work as long as
> the page returned from vmalloc_to_page() can be mapped.

You mean mapping a page that is mapped to the vmalloc area of the kernel
also to userland?  That's a fairly safe way to create cache aliases on
those platforms that suffer from them.

  Ralf
