Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388Ab0AGRI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab0AGRI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 12:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803Ab0AGRI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 12:08:27 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:40611 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab0AGRI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 12:08:27 -0500
Date: Thu, 7 Jan 2010 11:07:44 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC local_t removal V1 1/4] Add add_local() and
 add_local_return()
In-Reply-To: <20100105224901.GB32584@Krystal>
Message-ID: <alpine.DEB.2.00.1001071105360.901@router.home>
References: <20100105220417.400092933@quilx.com> <20100105220437.940473705@quilx.com> <20100105224901.GB32584@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010, Mathieu Desnoyers wrote:

> The problem I see here is that with ~5-6 operations, we will end up
> having 20*5 = 100 headers only for this. Can we combine these in a
> single header file instead ? local.h wasn't bad in this respect.

We could actually keep local.h and just thin it out a bit. Get rid of the
local_t type and use long instead? Then make the local_inc/local_add work
on an arbitrary scalar like cmpxchg_local?

> Also, separating all these in sub-files will make it a bit difficult to
> pinpoint errors that would arise from using a bad combination of, e.g.
> generic add with a non-protected read or set.

Yes surely I dont want many files. I thought about adding

#define inc_local(x) add_local(x, 1)

etc to add-local.h

