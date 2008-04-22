Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbYDVUXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbYDVUXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 16:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYDVUW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 16:22:57 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39354 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750892AbYDVUW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 16:22:56 -0400
Date: Tue, 22 Apr 2008 13:22:55 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Nick Piggin <npiggin@suse.de>, Jack Steiner <steiner@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Hugh Dickins <hugh@veritas.com>, akpm@linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 02 of 12] Fix ia64 compilation failure because of common
 code include bug
In-Reply-To: <3c804dca25b15017b220.1208872278@duo.random>
Message-ID: <Pine.LNX.4.64.0804221319430.3640@schroedinger.engr.sgi.com>
References: <3c804dca25b15017b220.1208872278@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like this is not complete. There are numerous .h files missing which 
means that various structs are undefined (fs.h and rmap.h are needed 
f.e.) which leads to surprises when dereferencing fields of these struct.

It seems that mm_types.h is expected to be included only in certain 
contexts. Could you make sure to include all necessary .h files? Or add
some docs to clarify the situation here.
