Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbXISU3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbXISU3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 16:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbXISU3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 16:29:31 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:40587 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbXISU3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 16:29:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=hyC/hZtRyUjyH9tvCiGXyhLPAnO+AOdMe4iicIrep/eJVKhzbDWkjEEaKOIZM+8VrmjSVUwdWxGKNgTViTGK7PwQiYZINpF6qprezn4Qe9st0Y7RxOCxNjNaPItWsu0tnagynZQKrrMLAEYNaBBi/h19T7fQmIZKEJGXnUQ5/UA=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "Michael Chan" <mchan@broadcom.com>
Subject: Re: bnx2 dirver's firmware images
Date: Wed, 19 Sep 2007 21:29:22 +0100
User-Agent: KMail/1.9.1
Cc: "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       "netdev" <netdev@vger.kernel.org>
References: <200709181823.26429.vda.linux@googlemail.com> <200709190930.39882.vda.linux@googlemail.com> <1190235642.9540.261.camel@dell>
In-Reply-To: <1190235642.9540.261.camel@dell>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709192129.23034.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 September 2007 22:00, Michael Chan wrote:
> On Wed, 2007-09-19 at 09:30 +0100, Denys Vlasenko wrote:
> +       /* gzip header (1f,8b,08... 10 bytes total + possible asciz filename)
> +        * is stripped, 32-bit unpacked size (LE) is prepended instead */
> +       sz = *zbuf++;
> +       sz = (sz << 8) + *zbuf++;
> +       sz = (sz << 8) + *zbuf++;
> +       sz = (sz << 8) + *zbuf++;
> 
> I don't have a problem with removing the gzip header.  It doesn't
> contain very useful information other than a valid header for sanity
> check.  But I don't think we need to arbitrarily add the unpacked size
> in front of the gzipped data.  The driver knows the size (e.g. the size
> of RAM on the chip) and should pass it to the call.  The driver should
> also allocate the memory for the unpacked data instead of allocating the
> memory inside the call and freeing it by the caller.  For example, the
> driver may need to use pci_alloc_consistent() if the firmware is to be
> DMA'ed to the chip.
> 
> Other than that, everything else looks fine.  Thanks.

Are you saying that you successfully run-tested it?
--
vda
