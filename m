Return-Path: <linux-kernel-owner+w=401wt.eu-S1751869AbZKQM66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbZKQM66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 07:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbZKQM65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 07:58:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41260 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750905AbZKQM65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 07:58:57 -0500
Date: Tue, 17 Nov 2009 12:59:01 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Kuninori Morimoto <morimoto.kuninori@renesas.com>,
       alsa-devel@alsa-project.org, linux-pm@lists.linux-foundation.org,
       Magnus Damm <damm@opensource.se>, linux-kernel@vger.kernel.org
Subject: Re: Null suspend/resume functions
Message-ID: <20091117125901.GF823@rakim.wolfsonmicro.main>
References: <ud43sjtaf.wl%morimoto.kuninori@renesas.com>
 <20091109105858.GB1245@sirena.org.uk>
 <20091109133136.GC1245@sirena.org.uk>
 <20091116153000.GB29479@sirena.org.uk>
 <aec7e5c30911170446n71031671i48aca11f5276405d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aec7e5c30911170446n71031671i48aca11f5276405d@mail.gmail.com>
X-Cookie: That's no moon...
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 09:46:35PM +0900, Magnus Damm wrote:

> On SuperH we have Runtime PM enabled on a few platforms together with
> a few updated drivers. The latest driver to become more power aware is
> this FSI driver.

I understand exactly what the runtime PM stuff and the driver are doing
here, the issue is the mandatory suspend and resume functions.

> At this point the SuperH specific platform bus code requires the
> callbacks ->runtime_suspend() and ->runtime_resume() to be present. It
> may be a good idea to allow them to be NULL in the future or maybe
> having some shared functions, but before starting to break out stuff
> I'd like to see how other Runtime PM implementations deal with this.
> So unless people object I prefer to keep it as-is for now.

What is the reason for requiring that the driver provide stub functions?
For me the issue is that if it's mandatory for the driver to provide the
functions then having stub functions in there makes the driver look like
it is abusing the API by not implementing mandatory functionality.

Given that the arch is now dealing with clocking and power for the
device using the runtime PM system it seems fairly clear that there are
going to be drivers like this one that can at least skip the suspend
part and may not need to do anything at resume time either.
