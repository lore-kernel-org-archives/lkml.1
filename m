Return-Path: <linux-kernel-owner+w=401wt.eu-S1755723AbXLKXil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbXLKXil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 18:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbXLKXid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 18:38:33 -0500
Received: from gate.crashing.org ([63.228.1.57]:39287 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953AbXLKXic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 18:38:32 -0500
Subject: Re: [RFC][POWERPC] Provide a way to protect 4k subpages when using
	64k pages
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Christoph Hellwig <hch@lst.de>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071211155305.GA28055@lst.de>
References: <18264.58263.818005.757831@cargo.ozlabs.ibm.com>
	 <20071211155305.GA28055@lst.de>
Content-Type: text/plain
Date: Wed, 12 Dec 2007 10:38:08 +1100
Message-Id: <1197416288.8385.21.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-12-11 at 16:53 +0100, Christoph Hellwig wrote:
> All these process would use plain mmap/
> mprotect to deal with the subpage protections.

That seems very hard to do ... all of the generic code here only knows
about the base page size, so except if we're going to fully re-implement
the mmap/mprotect logic from scratch, it's going to hurt, or am I
missing something ?

I suppose we could add wrappers to those syscalls that always set the
protection map to "no access" over the target area (from within
get_unmapped_area for mmap as we don't know the area yet), and then,
update it after the successful call.

But mprotect seems a clumsy way to control the per-sub-page permission
in that case as we don't want to change the underlying real 64k page
permission.

Ben.
 

