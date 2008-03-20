Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbYCTLro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbYCTLro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 07:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbYCTLrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 07:47:35 -0400
Received: from mail3.iitk.ac.in ([203.200.95.132]:49230 "EHLO mail3.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535AbYCTLre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 07:47:34 -0400
X-Greylist: delayed 2046 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Mar 2008 07:47:34 EDT
Date: Thu, 20 Mar 2008 16:43:13 +0530 (IST)
From: Arun Raghavan <arunsr@cse.iitk.ac.in>
X-X-Sender: arun@peripatetic.hades
To: David Howells <dhowells@redhat.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [keys] Always use key_get() to increment key refcount
In-Reply-To: <8036.1205965746@redhat.com>
Message-ID: <Pine.LNX.4.64.0803201639590.30696@peripatetic.hades>
References: <Pine.LNX.4.64.0803200227440.22605@peripatetic.hades>
 <8036.1205965746@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008, David Howells wrote:

> Arun Raghavan <arunsr@cse.iitk.ac.in> wrote:
> 
> > Patch to use key_get() wherever the keys code manually increments the
> > key refcount.
> > 
> > This should make debugging a little simpler for clients, since it
> > becomes easier to track where a key's refcount changes.
> 
> The problem with this is that key_get() is not simply an atomic_inc().  You
> end up introducing an extra conditional into each of these places where one is
> not required.  Now it's possible that the compiler's optimiser is sufficiently
> clever to get rid of them all, but do you guarantee that?

Is this really a significant performance penalty? If yes, wouldn't a
likely() be sufficient to mitigate the penalty?

The same arguments should also be applied to key_put(), I guess.

Regards,
Arun
