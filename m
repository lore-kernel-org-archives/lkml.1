Return-Path: <linux-kernel-owner+w=401wt.eu-S1761470AbYCYX4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761470AbYCYX4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 19:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756231AbYCYXz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 19:55:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:24204 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869AbYCYXz5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 19:55:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,555,1199692800"; 
   d="scan'208";a="539956273"
X-MIMEOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: larger default page sizes...
Date: Tue, 25 Mar 2008 16:49:23 -0700
Message-ID: <1FE6DD409037234FAB833C420AA843ECE9E2CA@orsmsx424.amr.corp.intel.com>
In-reply-to: <20080325.163240.102401706.davem@davemloft.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: larger default page sizes...
Thread-Index: AciO0YIlyjg9GQexRcW7W5ufmVfZRAAAB2EQ
References: <18408.29107.709577.374424@cargo.ozlabs.ibm.com><20080324.211532.33163290.davem@davemloft.net><18408.59112.945786.488350@cargo.ozlabs.ibm.com> <20080325.163240.102401706.davem@davemloft.net>
From: "Luck, Tony" <tony.luck@intel.com>
To: "David Miller" <davem@davemloft.net>, <paulus@samba.org>
Cc: <clameter@sgi.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
       <linux-ia64@vger.kernel.org>, <torvalds@linux-foundation.org>
X-OriginalArrivalTime: 25 Mar 2008 23:49:24.0607 (UTC) FILETIME=[DADA38F0:01C88ED2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > How do I get gcc to use hugepages, for instance?
>
> Implementing transparent automatic usage of hugepages has been
> discussed many times, it's definitely doable and other OSs have
> implemented this for years.
>
> This is what I was implying.

"large" pages, or "super" pages perhaps ... but Linux "huge" pages
seem pretty hard to adapt for generic use by applications.  They
are generally a somewhere between a bit too big (2MB on X86) to
way too big (64MB, 256MB, 1GB or 4GB on ia64) for general use.

Right now they also suffer from making the sysadmin pick at
boot time how much memory to allocate as huge pages (while it
is possible to break huge pages into normal pages, going in
the reverse direction requires a memory defragmenter that
doesn't exist).

Making an application use huge pages as heap may be simple
(just link with a different library to provide with a different
version of malloc()) ... code, stack, mmap'd files are all
a lot harder to do transparently.

-Tony
