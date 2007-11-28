Return-Path: <linux-kernel-owner+w=401wt.eu-S1760637AbXK1TUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637AbXK1TUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 14:20:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756272AbXK1TU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 14:20:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43768 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755594AbXK1TU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 14:20:28 -0500
To: "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
References: <200711281242.52941.tvrtko.ursulin@sophos.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 28 Nov 2007 20:20:26 +0100
In-Reply-To: <200711281242.52941.tvrtko.ursulin@sophos.com>
Message-ID: <p738x4i9nyd.fsf@crumb.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com> writes:

> We here at Sophos (the fourth largest endpoint security vendor in the world) 
> have such a module called Talpa which is a part of our main endpoint security 
> product

What is a "endpoint security product" exactly? A gateway that scans
files passing through it?

> In essence, what our module does is it intercepts file accesses and allows 
> userspace daemons to vet them.

I suspect the only good way forward would be to collect the
requirements of your user space and then define a proper official
interface to do what they want to do. Ideally would be a shared proposal
from multiple groups who are doing this, e.g. if you could talk to
some others doing similar things that would be best.

Personally I admit I never quite saw the point of intercepting all
file accesses for everything. That will just always be slow as often
demonstrated on other operating systems and racey and unreliable too.
And at least the internal daemons should be already reasonably well
protected by standard (or beyond standard, like AA/SELinux etc.)
security measures, so e.g. it does not really make sense to intercept
all of your /etc file accesses and similar.

It might be better to identify the services (gateway, samba, file
server whatever) that are actually dealing with possible infected
"external" files and then define some generic interface that would
allow you to check those as the data appears.

I would expect such an approach to perform better in the end and be more
reliable too.

Note such a interface might well be user space only.

-Andi
