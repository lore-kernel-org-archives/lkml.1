Return-Path: <linux-kernel-owner+w=401wt.eu-S966012AbXJPV3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966012AbXJPV3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 17:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760117AbXJPV3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 17:29:11 -0400
Received: from thunk.org ([69.25.196.29]:39298 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755140AbXJPV3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 17:29:09 -0400
Date: Tue, 16 Oct 2007 17:28:53 -0400
From: Theodore Tso <tytso@mit.edu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [patch][rfc] rewrite ramdisk
Message-ID: <20071016212853.GB1314@closure.lan>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Borntraeger <borntraeger@de.ibm.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <200710151028.34407.borntraeger@de.ibm.com> <m1abqjirmd.fsf@ebiederm.dsl.xmission.com> <200710161808.06405.nickpiggin@yahoo.com.au> <200710161747.12968.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710161747.12968.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 05:47:12PM +1000, Nick Piggin wrote:
> +	/*
> +	 * ram device BLKFLSBUF has special semantics, we want to actually
> +	 * release and destroy the ramdisk data.
> +	 */

We won't be able to fix completely this for a while time, but the fact
that BLKFLSBUF has special semantics has always been a major wart.
Could we perhaps create a new ioctl, say RAMDISKDESTORY, and add a
deperecation printk for BLKFLSBUF when passed to the ramdisk?  I doubt
there are many tools that actually take advantage of this wierd aspect
of ramdisks, so hopefully it's something we could remove in a 18
months or so...

							- Ted
