Return-Path: <linux-kernel-owner+w=401wt.eu-S1757842AbYLDUy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbYLDUy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 15:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbYLDUyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 15:54:47 -0500
Received: from igw2.watson.ibm.com ([129.34.20.6]:54411 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918AbYLDUyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 15:54:46 -0500
Subject: Re: [PATCH 2/6] integrity: Linux Integrity Module(LIM)
From: david safford <safford@watson.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <20081204130949.GA18196@infradead.org>
References: <cover.1228253618.git.zohar@linux.vnet.ibm.com>
	 <a9835f10cb3efd9951fa6e9fcc2e29f528ba625b.1228253618.git.zohar@linux.vnet.ibm.com>
	 <20081203123021.GA30035@infradead.org>
	 <1228328323.2821.30.camel@localhost.localdomain>
	 <20081203182300.GA31203@infradead.org>
	 <1228342655.2821.64.camel@localhost.localdomain>
	 <20081204130949.GA18196@infradead.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 04 Dec 2008 15:53:34 -0500
Message-Id: <1228424014.3014.58.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-04 at 08:09 -0500, Christoph Hellwig wrote:
>
> In integrity.h there are two operation vectors defines:

In the past, the integrity hooks were discussed with the 
LSM/security community, and others expressed interest in using 
them, and we were trying to accommodate their requests. On the 
other hand, we have separately asked them to chime in here to
defend these hooks, and have heard nothing. As everyone has
pointed out, if no one uses them, they are bloat, and if
someone else wants them in the future, they can easily be
added back. In a little more detail:

> - struct integrity_operations delcares the operations called from the
> VFS. This one is actually used. While I don't agree to Dave's
> argument, because we don't put bloat in just because people might
> eventually some day use it when they are in the right mood and the
> sun shines, thisn't isn't the one I'm talking about in this thread.

These hooks were for alternate integrity modules, and since
no one else has defended them, we have to agree that they
should be replaced with direct calls.

> - struct template_operations on the others is not only really badly
> named for appearing in a global header but also not used in a
> meaningfull way. There is one single instace of it,
> ima_template_ops, and while there are five helpers added in the
> second patch that use it (integrity_collect_measurement,
> integrity_appraise_measurement, integrity_store_measurement,
> integrity_store_template, integrity_must_measure) none of them
> is used at all during the patch series. There are two direct
> uses of these template added in the third path, to implement the
> show operations for the "binary_runtime_measurements" and
> "ascii_runtime_measurements" files ins securityfs, but given that
> those are inside ima there no reason for the indirection at all.

These hooks were for potential use by LSM modules to inquire about the
integrity of files, and for other modules to be able to anchor data
in the TPM list. Again, since no one has chimed in to defend the 
hooks, we have no problem removing them.

Sorry about arguing too long on this, and thanks for all the reviews...

dave
