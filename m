Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab0BTKfN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 05:35:13 -0500
Received: from casper.infradead.org ([85.118.1.10]:39924 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab0BTKfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 05:35:11 -0500
Subject: Re: Firmware versioning best practices II
From: David Woodhouse <dwmw2@infradead.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       Vipin Mehta <Vipin.Mehta@atheros.com>
In-Reply-To: <43e72e891002191823h3245bc0cn7a8745ae77409aa8@mail.gmail.com>
References: <43e72e891002191823h3245bc0cn7a8745ae77409aa8@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Feb 2010 10:35:06 +0000
Message-ID: <1266662106.1820.4034.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-19 at 18:23 -0800, Luis R. Rodriguez wrote:
> Last year, with the help of the community we at Atheros opened up the
> first (to my knowledge) firmware for a device driver used on the Linux
> kernel. The community has been advancing the firmware and making
> changes and even an alternative driver with more features is being
> baked. We hadn't dealt with open firmware before and this itself
> raises a few management questions about the firmware APIs, code
> revision and general best practices which are likely not documented
> anywhere. We reviewed this on linux-wireless last year [1] and Pavel
> Roskin made a good suggestion for model to follow. I still have a few
> more questions though and wanted a wider review on this.
> 
> I've documented a summary of what we have discussed and suggested so far here:
> 
> http://wireless.kernel.org/en/developers/Documentation/firmware-versioning
> 
> We should still address how drivers should deprecate firmware. Can we
> deprecate old firmware APIs from drivers on each kernel release? Any
> other comments or feedback?
> 
> [1] http://wireless.kernel.org/en/developers/Documentation/firmware-versioning
> 
>   Luis

So far it looks like you've just rewritten a subset of the rules for
handling shared library sonames.

I wouldn't suggest that including the API version as a _separate_ field
from the code version is best practice. Why not just bump the major # of
the code version when you change the API, just as we do with shared
libraries?

That doesn't prevent some people from using foo-$APIVER-$CODEVER if they
really have to, of course -- if they have firmware which can be
conditionally compiled for both old and new APIs, for example. But I
don't think it should be recommended.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

