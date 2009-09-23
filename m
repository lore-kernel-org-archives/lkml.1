Return-Path: <linux-kernel-owner+w=401wt.eu-S1753259AbZIWOQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbZIWOQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 10:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbZIWOQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 10:16:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53866 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbZIWOQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 10:16:47 -0400
Date: Wed, 23 Sep 2009 10:16:48 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Is nobh code still useful?
Message-ID: <20090923141648.GA15934@infradead.org>
References: <20090917135627.GB13660@duck.suse.cz> <4AB30AD1.7010400@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB30AD1.7010400@us.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 09:21:37PM -0700, Badari Pulavarty wrote:
> Originally it was supported on ext2. I added support nobh support for  
> ext3. At that time, the main
> issue/complaint was that, these bufferheads consume memory from  
> ZONE_NORMAL causing
> memory pressure on 32-bit (i386) configurations.

Yeah, I think that's a tradeof past it's days.  I'm all for nuking it,
and while we're at it we should also find a better way to integrate the
mpage bits.  Not using them is pretty dumb, so the default aops should
really be mpage if possible, else fall back without the need for
different sets of aops.

