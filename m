Return-Path: <linux-kernel-owner+w=401wt.eu-S1755871AbYDFRD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbYDFRD5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 13:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754609AbYDFRDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 13:03:47 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:50927 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567AbYDFRDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 13:03:44 -0400
Date: Sun, 6 Apr 2008 10:03:43 -0700 (PDT)
From: dean gaudet <dean@arctic.org>
To: Alexander van Heukelum <heukelum@mailshack.com>
cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: [PATCH] x86: generic versions of find_first_(zero_)bit, convert
 i386
In-Reply-To: <20080401094618.GA24862@mailshack.com>
Message-ID: <alpine.DEB.1.10.0804060958580.7751@twinlark.arctic.org>
References: <20080331171506.GA24017@mailshack.com> <20080401084710.GB4787@elte.hu> <20080401094618.GA24862@mailshack.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fwiw there's a way to do ffz / ntz which can do lg(n) conditional moves in 
parallel... i'm not sure what (non-x86) architectures this might be best 
on, but it might be a good choice for the generic code... although maybe 
the large number of constants required will be a burden on RISC 
processors.

take a look at figure 5-17 here http://hackersdelight.org/revisions.pdf

int ntz(unsigned x) {
	unsigned y, bz, b4, b3, b2, b1, b0;
	y = x & -x; // Isolate rightmost 1-bit.
	bz = y ? 0 : 1; // 1 if y = 0.
	b4 = (y & 0x0000FFFF) ? 0 : 16;
	b3 = (y & 0x00FF00FF) ? 0 : 8;
	b2 = (y & 0x0F0F0F0F) ? 0 : 4;
	b1 = (y & 0x33333333) ? 0 : 2;
	b0 = (y & 0x55555555) ? 0 : 1;
	return bz + b4 + b3 + b2 + b1 + b0;
}

-dean
