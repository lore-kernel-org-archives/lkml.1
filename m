Return-Path: <linux-kernel-owner+w=401wt.eu-S1760716AbXH2WS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760716AbXH2WS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 18:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbXH2WSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 18:18:18 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:40704 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbXH2WSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 18:18:17 -0400
Subject: Re: [-mm PATCH]  Memory controller improve user interface
From: Dave Hansen <haveblue@us.ibm.com>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>,
       Linux Containers <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>
In-Reply-To: <46D5ED5C.9030405@linux.vnet.ibm.com>
References: <20070829111030.9987.8104.sendpatchset@balbir-laptop>
	 <1188413148.28903.113.camel@localhost>
	 <46D5ED5C.9030405@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 29 Aug 2007 15:18:14 -0700
Message-Id: <1188425894.28903.140.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-30 at 03:34 +0530, Balbir Singh wrote:
> I've thought about this before. The problem is that a user could
> set his limit to 10000 bytes, but would then see the usage and
> limit round to the closest page boundary. This can be confusing
> to a user. 

True, but we're lying if we allow a user to set their limit there,
because we can't actually enforce a limit at 8,192 bytes vs 10,000.
They're the same limit as far as the kernel is concerned.

Why not just -EINVAL if the value isn't page-aligned?  There are plenty
of interfaces in the kernel that require userspace to know the page
size, so this shouldn't be too difficult.

-- Dave

