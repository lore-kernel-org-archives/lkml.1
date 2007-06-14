Return-Path: <linux-kernel-owner+w=401wt.eu-S1753060AbXFNRJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbXFNRJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 13:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbXFNRJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 13:09:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51384 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbXFNRJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 13:09:04 -0400
Date: Thu, 14 Jun 2007 18:09:01 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
       Holger Schurig <hs4233@mail.mn-solutions.de>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: libertas (private) ioctls vs. nl80211
Message-ID: <20070614170901.GA13384@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	Holger Schurig <hs4233@mail.mn-solutions.de>, akpm@osdl.org,
	linux-kernel@vger.kernel.org
References: <1181757483.29767.99.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181757483.29767.99.camel@johannes.berg>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Independent of any nl80211 status the private libertas ioctls have to
go.  Not only don't we want private ioctls for mesh networking but rather
have it as driver-independent interface, but the actual libertas interface
is the worst possible choice.  It uses the absolutely broken iwpriv interface
instead of plain ioctls, and has a cmpletely confusing forest of sub ioctls.

I strongly recommend ripping out all the ioctls for 2.6.22 and waiting for
a proper interface to appear.  The olpc people can patch the ioctls back
in for their use, but we should not put in interface like this into the
upstream kernel.  All NIC vendors get pushed back badly when they try
to put in less crappy ioctls, there is no reason to make a exception for
libtertas just because it's used by a project that some of the involved
maintainers like a lot.
