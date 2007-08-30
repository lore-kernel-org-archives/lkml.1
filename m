Return-Path: <linux-kernel-owner+w=401wt.eu-S1760388AbXH3QVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760388AbXH3QVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 12:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757776AbXH3QVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 12:21:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755061AbXH3QVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 12:21:13 -0400
Subject: Re: [PATCH 00/23] drm: introduce drm_zalloc
From: Kristian =?ISO-8859-1?Q?H=F8gsberg?= <krh@redhat.com>
To: Dave Airlie <airlied@linux.ie>
Cc: Christoph Hellwig <hch@infradead.org>, m.kozlowski@tuxland.pl,
       akpm@linux-foundation.org, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0708282149180.15296@skynet.skynet.ie>
References: <20070827205750.514001000@tuxland.pl>
	 <20070828200821.GA7998@infradead.org>
	 <Pine.LNX.4.64.0708282149180.15296@skynet.skynet.ie>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 12:20:32 -0400
Message-Id: <1188490832.7269.6.camel@hinata.boston.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.90 (2.11.90-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-08-28 at 21:50 +0100, Dave Airlie wrote:
> On Tue, 28 Aug 2007, Christoph Hellwig wrote:
> 
> > On Mon, Aug 27, 2007 at 10:57:50PM +0200, m.kozlowski@tuxland.pl wrote:
> >> Hello,
> >>
> >> 	As there are many places in drm code where drm_alloc + memset is used
> >> this patch series introduces drm_zalloc and also makes use of drm_calloc where
> >> needed. Most of these patches save some bytes so the benefit is a few kB saved
> >> (gcc 4.1.2) with patch applied. Also some small (style, etc.) things are fixed.
> >> This patch series does the conversion drm tree-wide. All patches were compile
> >> tested.
> >
> > Please just convert it to plain kzalloc/kcalloc and kill these utterly useless
> > wrappers instead.
> >
> >
> 
> The wrappers aren't useless the drm alloc/free passes in a memory space 
> for debugging purposes so we can track memory abuse when developing,

Do we ever use that, though?  Having to pass in the pointer, the size
and the area just to free memory, sure is a bitch.

> but drm_zalloc shouldjust alias to drm_calloc really..

drm_calloc calls kcalloc which performs an integer overflow check on the
'n' and 'size' arguments, which isn't needed for drm_zalloc.  Small
detail, of course, but I don't see the problem with aliasing to kzalloc.

Kristian


