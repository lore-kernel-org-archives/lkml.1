Return-Path: <linux-kernel-owner+w=401wt.eu-S1751964AbZHRDSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbZHRDSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 23:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbZHRDSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 23:18:55 -0400
Received: from ozlabs.org ([203.10.76.45]:35742 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbZHRDSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 23:18:54 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: kernel segv with 2.6.31-rc6 ?
Date: Tue, 18 Aug 2009 12:48:52 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-14-generic; KDE/4.2.2; i686; ; )
Cc: Helge Deller <deller@gmx.de>,
       "linux-parisc" <linux-parisc@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4A89CC4D.5040801@gmx.de> <1250549376.7858.96.camel@mulgrave.site>
In-Reply-To: <1250549376.7858.96.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908181248.52572.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Aug 2009 08:19:36 am James Bottomley wrote:
> The root cause is a duplicate section name (.text); is this legal?

I'd be happy to fail to load it.  There might be sysfs issues with it
too.

> However, there's a problem with commit
> 6d76013381ed28979cd122eb4b249a88b5e384fa in that if you fail to allocate
> a mod->sect_attrs (in this case it's null because of the duplication),
> it still gets used without checking in add_notes_attrs()
> 
> This should fix it

No, the real problem is that it ignores failure.  I'd much rather fail
the module load than various features mysteriously MIA.

Which brings us to "patches which don't go thru the maintainer" (or
perhaps, non-responsive maintainers who get bypassed).

Thanks,
Rusty.
