Return-Path: <linux-kernel-owner+w=401wt.eu-S1752245AbXDBQSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245AbXDBQSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 12:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbXDBQSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 12:18:18 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50349 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752346AbXDBQSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 12:18:16 -0400
Date: Mon, 2 Apr 2007 09:18:16 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Martin Bligh <mbligh@google.com>, linux-mm@kvack.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/4] x86_64: Switch to SPARSE_VIRTUAL
In-Reply-To: <200704011246.52238.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0704020914280.30634@schroedinger.engr.sgi.com>
References: <20070401071024.23757.4113.sendpatchset@schroedinger.engr.sgi.com>
 <20070401071029.23757.78021.sendpatchset@schroedinger.engr.sgi.com>
 <200704011246.52238.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Apr 2007, Andi Kleen wrote:

> Or do you have overlaps with other memory (I think you have)

We may get into a case where some page structs are physically located
on other nodes if there are no holes between nodes. This would be 
particularly significant for 64MB node sizes using numa emulation.
But there it really does not matter where the real memory is located.
(this is really inherent in sparsemems way of mapping memory).

> In that case you have to handle the overlap in change_page_attr()

Why would we use change_page_attr on page structs? I can see that the 
pages themselves should be subject to change_page_attr but why the 
page_structs? I think the system would panic if one would set page structs 
to read only.

