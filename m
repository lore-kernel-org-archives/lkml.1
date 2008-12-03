Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbYLCVsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbYLCVsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 16:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbYLCVso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 16:48:44 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:35238 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbYLCVso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 16:48:44 -0500
Subject: Re: [patch 2.6.28-rc7] regulator: catch some registration errors
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Mark Brown <broonie@sirena.org.uk>, lkml <linux-kernel@vger.kernel.org>,
       davej@redhat.com
In-Reply-To: <200812012150.36342.david-b@pacbell.net>
References: <200812011335.43551.david-b@pacbell.net>
	 <20081201225312.GA6699@sirena.org.uk>
	 <200812012150.36342.david-b@pacbell.net>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 21:48:41 +0000
Message-Id: <1228340921.6529.80.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-01 at 21:50 -0800, David Brownell wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
> 
> Prevent registration of duplicate "struct regulator" names.
> They'd be unavailable, and clearly indicate something wrong.

This part is fine.

> 
> Also make sure the consumer device is provided.  It's nonsensical
> to omit these, and not a documented part of the interface.  Since
> no code in mainline does such stuff, this is just anti-oops medicine.
> 

I think Mark has probably mentioned the need to support CPUfreq drivers
with no struct device. I had a quick scan of the current in tree ARM
CPUfreq drivers and could not find one that uses struct device (someone
will now find one). 

I wonder if there is another way to approach this as I do agree that
passing NULL is probably not the best solution. Alternatives like
embedding struct device with the CPUfreq core or adding a regulator_get
API call for CPUfreq drivers all involve some work. Fwiw, I'd be happy
enough with the latter option.

Thanks

Liam

