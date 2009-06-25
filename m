Return-Path: <linux-kernel-owner+w=401wt.eu-S1752134AbZFYUgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbZFYUgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 16:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbZFYUgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 16:36:07 -0400
Received: from mail2.cray.com ([136.162.64.100]:40908 "EHLO mail2.cray.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbZFYUfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 16:35:52 -0400
Date: Thu, 25 Jun 2009 13:35:31 -0700
From: Kyle Hubert <khubert@cray.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, Igor Gorodetsky <igorodet@cray.com>
Subject: Re: 2.6 Makefile replacement for VPATH
Message-ID: <20090625203531.GO6248@cray.com>
References: <20090625163916.GN6248@cray.com> <20090625174748.GA15168@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090625174748.GA15168@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Cray-VirusStatus: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 07:47:48PM +0200, Sam Ravnborg wrote:
> > I refer to VPATH with regards to the situation where you can have
> > multiple Makefiles target the same source file to build different
> > objects. In particular, we are using the same source file recompiled
> > with different options to be able to support different devices.
>
> Several obvious solutions.
>
> a) Let the same driver handle multiple devices - we do this in very often.
>
> b) Keep all shared functionality in a dedicated lib* module, and
> have thin wrappers for the actual drivers. See libata for example.

Neither one of them were options for us, since header files also have
macros for defining MMR addresses in the hardware. This can change
from device to device, so the code becomes more complicated to
organize that in a shared driver/library.

> c) The ugly where you have a thin dedicated .C file for each driver
> that includes the source they share.

Thanks for the suggestion. We tried this, and it does indeed solve our
problem. It may be ugly, but it's the cleanest of the four solutions.

Thank you for the response,
-Kyle Hubert
