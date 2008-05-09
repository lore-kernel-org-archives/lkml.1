Return-Path: <linux-kernel-owner+w=401wt.eu-S1753678AbYEIS4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbYEIS4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 14:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbYEIS4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 14:56:31 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:2090 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763189AbYEIS43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 14:56:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=mJHDh/PMBNjayoxoPPkGk+YF33BCGuSsQojImc6fZF/6R0RIv5C2lZvc/sDVif6UJpIJj28pf9wHEEdHMXYJr3MKsnQCk9Gjy18K3puZkYLvO4Dae6IRtDvmrfzpPREwbjLBohZ3CON5trV1O0nOQroA+U1N+2W8+6/ihg3Md3Y=
Date: Fri, 9 May 2008 23:51:49 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jay Cliburn <jacliburn@bellsouth.net>
Cc: Luca Tettamanti <kronos.it@gmail.com>, Chris Snook <csnook@redhat.com>,
       Jeff Garzik <jeff@garzik.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Christoph Lameter <clameter@sgi.com>,
       torvalds@osdl.org
Subject: Re: atl1 64-bit => 32-bit DMA borkage (reproducible, bisected)
Message-ID: <20080509195149.GA4985@martell.zuzino.mipt.ru>
References: <20080419215444.2d4623f5@osprey.hogchain.net> <20080420111453.GA4902@martell.zuzino.mipt.ru> <20080420060607.2b1be48b@osprey.hogchain.net> <20080420122631.GA4761@martell.zuzino.mipt.ru> <20080420133704.63f5cc10@osprey.hogchain.net> <20080420205500.GA4762@martell.zuzino.mipt.ru> <20080421210821.28053a92@osprey.hogchain.net> <20080425195743.2bfe66ee@osprey.hogchain.net> <20080504211507.GC1040@martell.zuzino.mipt.ru> <20080506110225.31fd61a4@osprey.hogchain.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506110225.31fd61a4@osprey.hogchain.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmmm, there was a wonderful oops on interface stop here when the other end
of atl1 cable was physically unplugged (but there was traffic before):

	atl1_down
	atl1_clean_rx_ring
	swiotlb_unmap_single
	swiotlb_unmap_single_attrs
	memcpy_c

