Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbYC1RW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbYC1RW3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 13:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbYC1RWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 13:22:21 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:52234 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829AbYC1RWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 13:22:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=A2nHhcaW0ag6Zpfs60bTUpM1CeJxQw5H/UikFhiuMz2ga/186NS/MFy6mz+kjdkq4eqdBqd3rRfgeu7Fty2q78eiWUoJ0RMxacGNhNZn0ti8JTgvaq2uAvFBFIHBZ3CIpwQ8W50m240k5uzMYKBZUTUS6AyFe+M042ApLAnPfSY=
Message-ID: <84144f020803281015s60370d9dpec0913c33004b6c2@mail.gmail.com>
Date: Fri, 28 Mar 2008 19:15:02 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
Cc: "Christoph Lameter" <clameter@sgi.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Pawel Staszewski" <pstaszewski@artcom.pl>,
       LKML <linux-kernel@vger.kernel.org>, "Adrian Bunk" <bunk@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Natalie Protasevich" <protasnb@gmail.com>
In-Reply-To: <alpine.LFD.1.00.0803272050290.14670@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803272353.51901.rjw@sisk.pl>
	 <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0803272002090.11979@schroedinger.engr.sgi.com>
	 <alpine.LFD.1.00.0803272050290.14670@woody.linux-foundation.org>
X-Google-Sender-Auth: 74a3f1bff8e8d3e3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Fri, Mar 28, 2008 at 6:00 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>  And the fact is, passing in GFP_ZERO from the SLUB code is a bug
>  regardless, because it unnecessarily does the dual memset().

We clear GFP_ZERO in new_slab() so the normal kmalloc()/kzalloc() path
should be fine but don't do it for kmalloc_large() nor
kmalloc_large_node(). Is that the bug here?
