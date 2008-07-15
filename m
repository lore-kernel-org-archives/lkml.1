Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbYGOGDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbYGOGDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 02:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbYGOGD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 02:03:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38139 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbYGOGD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 02:03:27 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied
	from	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: david@lang.hm
Cc: Arjan van de Ven <arjan@infradead.org>, David Miller <davem@davemloft.net>,
       torvalds@linux-foundation.org, rene.herman@keyaccess.nl,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0807142241040.6370@asgard>
References: <487C0A12.9060906@keyaccess.nl>
	 <20080714.192425.241878700.davem@davemloft.net>
	 <alpine.LFD.1.10.0807141934060.3017@woody.linux-foundation.org>
	 <20080714.194557.78177585.davem@davemloft.net>
	 <20080714215648.1ed29448@infradead.org>
	 <1216098546.27455.190.camel@shinybook.infradead.org>
	 <alpine.DEB.1.10.0807142241040.6370@asgard>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 23:03:15 -0700
Message-Id: <1216101795.27455.213.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-14 at 22:45 -0700, david@lang.hm wrote:
> linus pointed out that the documentation reccomended the
> request_firmware();load_firmware();release() approach and stated that that 
> approach was the wrong way to do things, instead doing a request_firmware 
> early and release when the module is unloaded.
> 
> does this patch series follow the documented reccomendation? or does it 
> follow the more concervative approach Linus pointed out? (it's far faster 
> to ask then to search Internet archives for the patches)

Mostly it follows the documented recommendation, since most of the
touched drivers are USB drivers and you end up re-enumerating and
starting from scratch on resume anyway. And the remainder are so old
that they don't have suspend/resume support anyway. Remember, we're only
really updating the older drivers; newer drivers tend to use
request_firmware() already, and have done for years.

The only one I remember offhand that loads the firmware and keeps it
around is tg3 -- and I didn't ask Linus to pull that one. In fact, we
only did it that way for tg3 since that driver seems to doing _all_ its
chip reset and firmware reload (including a boatload of udelays) within
a spinlock. That in itself is probably not optimal, but it wasn't really
within the scope of what we were doing to fix it.

-- 
dwmw2

