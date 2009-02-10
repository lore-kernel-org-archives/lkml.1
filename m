Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbZBJD1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbZBJD1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 22:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752417AbZBJD1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 22:27:40 -0500
Received: from ozlabs.org ([203.10.76.45]:37071 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbZBJD1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 22:27:40 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: Re: [PATCH 5/6] module: make modversion_info contain a pointer, not an array.
Date: Tue, 10 Feb 2009 13:57:34 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>
References: <200901290005.52819.rusty@rustcorp.com.au> <200902071254.28824.rusty@rustcorp.com.au> <20090209175050.GB9486@mediacenter>
In-Reply-To: <20090209175050.GB9486@mediacenter>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902101357.34716.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 February 2009 04:20:50 Shawn Bohrer wrote:
> This also results in a taint flag of 3.  So I'm thinking the regression
> here is that somewhere between 2.6.25 (I know openSUSE 11 worked too)
> and 2.6.27 the kernel stopped allowing modules to load if they didn't
> build with modversion support and the kernel was built with
> CONFIG_MODVERSIONS=y.

Before 2.6.26, the kernel ignored the vermagic field when
CONFIG_MODVERSIONS=y.  I changed it to only ignore vermagic *if* there
were CRCs.

If you use modprobe --force, you should be able to load a non-modversions
module into a modversions kernel.

> > And anyway, what was the symbol name which is over 56 characters long which
> > started this?
> 
> Yeah, that is an interesting question isn't it?  Let me just say that
> namespaces and name mangling make it really easy to have names longer
> than 56 characters.

Yes, C++.  This is one reason we don't support it.

Hope that helps,
Rusty.
