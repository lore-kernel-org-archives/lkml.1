Return-Path: <linux-kernel-owner+w=401wt.eu-S1760968AbXISPHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760968AbXISPHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 11:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760730AbXISPHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 11:07:24 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:21365 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760178AbXISPHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 11:07:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=e5P9OypInWNAadSwnzvshlnGznnQzAVTBKSy3/h3GHEQgiUgQW+1ZGAdNpA8drQ/L0wISuc+qou1rs83Z+N1cwBaH/av5rNbokpVI6m6OCd8MyNMhYCQH8x1g8+CnR9U1O8n+OHugCrJWMng6EuxzSnqadwWfCqqufzA8f+laME=
Message-ID: <40f31dec0709190807k5ea36ce8h615764a49c49efc@mail.gmail.com>
Date: Wed, 19 Sep 2007 18:07:17 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Clarify pci_iomap() usage for MMIO-only devices
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070918232546.004af9ff@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <43e72e890709171322x76ab6b70xd29bf97e3643c553@mail.gmail.com>
	 <20070918113401.6a8a737f@the-village.bc.nu>
	 <43e72e890709181146s604e0f9fl8b0c16627469c77f@mail.gmail.com>
	 <alpine.LFD.0.999.0709181159440.16478@woody.linux-foundation.org>
	 <20070918232546.004af9ff@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/9/19, Alan Cox <alan@lxorguk.ukuu.org.uk>:
> > If you use ioport_map/unmap, then you really *should* access them with the
> > proper iomem accessors (ioread/iowrite). The fact that it may happen to
> > work (when using the default lib/iomap.c implementation, at least) on
> > some architectures and with the current implementation still doesn't mean
> > that you should necessarily use readb/writeb.
>
> Another reason we should enforce the use of ioread/iowrite is that some
> platforms do daft things like map mmio type devices through indirect
> register access. Sparc PCMCIA is a classic example. The only sane way to
> make these work is to require ioread/iowrite is used with iomap
>

Hmm, we 've had bug reports about driver (madwifi-old-openhal) not
working on Sparc64, can someone test if this is the case (the fact
that we used readl/writel instead of ioread/iowrite on
madwifi-old-openhal) ? It was really weird because we handle
big-endian machines ok (madwifi-old-openhal on ppc worked fine).

(ath5k was based on madwifi-old-openhal)

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
