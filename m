Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbYEVR6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbYEVR6i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 13:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755985AbYEVR63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 13:58:29 -0400
Received: from sous-sol.org ([216.99.217.87]:52059 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756970AbYEVR62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 13:58:28 -0400
Date: Thu, 22 May 2008 10:58:03 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Dave Jones <davej@codemonkey.org.uk>, Andrew Morgan <morgan@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, bojan@rexursive.com
Subject: Re: capget() overflows buffers.
Message-ID: <20080522175744.GE4018@sequoia.sous-sol.org>
References: <20080522140402.GB2071@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522140402.GB2071@codemonkey.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Jones (davej@codemonkey.org.uk) wrote:
> We had a user file a bug report recently that sys_capget is overflowing
> a user buffer.
> 
> More details and test program are available at
> https://bugzilla.redhat.com/show_bug.cgi?id=447518
> 
> The only recent change in this area was e338d263a76af78fe8f38a72131188b58fceb591
> "Add 64-bit capability support to the kernel".

Yes, this thing is broken.

Trouble is, it's expecting an array of 2, and getting an array of 1.

The userspace fix is to do this (note, this does not fix the fact that
the ABI is broken, it's so opaque that it's difficult to follow).

cap_user_data_t data=malloc(sizeof(*data)*_LINUX_CAPABILITY_U32S);

Bojan, is there a capset involved as well, because that will pull in
garbage and set caps accordingly?
