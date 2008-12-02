Return-Path: <linux-kernel-owner+w=401wt.eu-S1753387AbYLBVha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbYLBVha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 16:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYLBVhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 16:37:19 -0500
Received: from vena.lwn.net ([206.168.112.25]:46695 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbYLBVhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 16:37:17 -0500
Date: Tue, 2 Dec 2008 14:37:15 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Chris Wright <chrisw@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Chris Wright <chrisw@redhat.com>,
       Izik Eidus <ieidus@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
       aarcange@redhat.com, avi@redhat.com, dlaor@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com, cl@linux-foundation.org
Subject: Re: [PATCH 3/4] add ksm kernel shared memory driver.
Message-ID: <20081202143715.1fa03879@bike.lwn.net>
In-Reply-To: <20081202212411.GG17607@acer.localdomain>
References: <1226888432-3662-1-git-send-email-ieidus@redhat.com>
	<1226888432-3662-2-git-send-email-ieidus@redhat.com>
	<1226888432-3662-3-git-send-email-ieidus@redhat.com>
	<1226888432-3662-4-git-send-email-ieidus@redhat.com>
	<20081128165806.172d1026@lxorguk.ukuu.org.uk>
	<20081202180724.GC17607@acer.localdomain>
	<20081202181333.38c7b421@lxorguk.ukuu.org.uk>
	<20081202212411.GG17607@acer.localdomain>
Organization: LWN.net
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2008 13:24:11 -0800
Chris Wright <chrisw@redhat.com> wrote:

> > Using current known techniques. A random collision is just as bad
> > news.  
> 
> And, just to clarify, your concern would extend to any digest based
> comparison?  Or are you specifically concerned about sha1?

Wouldn't this issue just go away if the code simply compared the full
pages, rather than skipping the hashed 128 bytes at the beginning?
Given the cost of this whole operation (which, it seems, can involve
copying one of the pages before testing for equality), skipping the
comparison of 128 bytes seems like a bit of a premature optimization.

jon
