Return-Path: <linux-kernel-owner+w=401wt.eu-S1758344AbZBDVBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344AbZBDVBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 16:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbZBDVA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 16:00:59 -0500
Received: from movementarian.org ([79.99.65.163]:50442 "EHLO movementarian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354AbZBDVA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 16:00:58 -0500
Date: Wed, 4 Feb 2009 16:00:37 -0500
From: wli@movementarian.org
To: Roland Dreier <rdreier@cisco.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Eli Cohen <eli@mellanox.co.il>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: FW: [PATCH] powerpc/mm: Export HPAGE_SHIFT
Message-ID: <20090204210037.GC10229@movementarian.org>
References: <20090203164930.GA10101@mtls03> <ada8wonnh3t.fsf@cisco.com> <1233712248.16867.131.camel@pasglop> <20090203211329.d6190a08.akpm@linux-foundation.org> <aday6wmn2vr.fsf@cisco.com> <20090203222601.747ca8b7.akpm@linux-foundation.org> <adad4dym2zp.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adad4dym2zp.fsf@cisco.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 11:11:22AM -0800, Roland Dreier wrote:
> Heh.  Looking into the implementation, it seems that I could actually do
> 	PAGE_SIZE << compound_order(page)
> directly (since there's no reason to go from size to hstate and back to
> size.  I don't know all the details of these VM internals, but that
> seems to only work on the first (small) page of a giant page?  Which
> causes problems for what we're trying to do here...

You should be able to find the head of a compound page using the
compound_head() inline, so try

	PAGE_SIZE << compound_order(compound_head(page))


-- wli
