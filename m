Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbZA1LIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbZA1LIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 06:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750995AbZA1LIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 06:08:23 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:46046 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbZA1LIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 06:08:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Mz4QhEW17uWzL0FmRCmKvxh55jPiH8pqtYIIfAAvOKE+6q5bmMwRYVWvs83A6Gx7my
         AU4c0Sjfdz6IdMgp7GntpbLlTUYEej+Zfmp4B64mYa7C9JQmcgCsZ/EO6brBEhzXlK09
         8PIrB3D2EhrB+IwvVI3kgZvKbHJaGIZDS7I+8=
MIME-Version: 1.0
In-Reply-To: <20090128053204.GB8720@brong.net>
References: <20090128033824.GA1662@brong.net>
	 <59410684d947bc68862a4f5d6c2a5bb1f29519ee.1233114169.git.brong@fastmail.fm>
	 <alpine.DEB.1.10.0901271949070.20262@alien.or.mcafeemobile.com>
	 <20090128053204.GB8720@brong.net>
Date: Wed, 28 Jan 2009 12:08:20 +0100
Message-ID: <19f34abd0901280308w18407fd5rd4d7d95e3799cf60@mail.gmail.com>
Subject: Re: [PATCH 1/3] epoll: increase default max_user_instances to 1024
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Bron Gondwana <brong@fastmail.fm>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2009 at 6:32 AM, Bron Gondwana <brong@fastmail.fm> wrote:
> That's clearly not happening here - so it seems that maybe our "happy
> medium" is actually in closer inspection of what's going on rather than
> a blanket low N to keep N^2 down.

Mh, could another solution to this all be to limit the number times
you can add a single epoll descriptor to another descriptor's set?

So you would still get the "upwards cascading" behaviour (i.e. A can
monitor B and C), but the "downwards cascading" would be prohibited
(i.e. B and C can't both monitor A).

I think this is a reasonable alternative, which would again allow a
number of epoll instances limited only by the number of open file
descriptors.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
