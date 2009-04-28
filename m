Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbZD1IjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbZD1IjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 04:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbZD1IjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 04:39:00 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59093 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbZD1Ii7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 04:38:59 -0400
Date: Tue, 28 Apr 2009 09:38:57 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.30-rc3] regulator: regression fix
Message-ID: <20090428083856.GD14626@sirena.org.uk>
References: <200904271959.40526.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904271959.40526.david-b@pacbell.net>
X-Cookie: A company is known by the men it keeps.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 07:59:40PM -0700, David Brownell wrote:

> By removing the "else", it breaks the handling of fixed-voltage
> regulators ... turning a non-error/non-warning situation into
> a complete init failure, which can then prevent system startup.

The change you're making isn't relevant to what I suspect the actual
problem is (you didn't specify, I may be wrong here).

For fixed voltage regulators either the user will have specified a
voltage constraint (in which case we'll fall into your else case since
cmin ought to be non-zero) or they won't (in which case it's the default
constraint code you added will fill it in).  The problem I think you're
seeing is that the code you added to fill in a default constraint for
fixed voltage regulators uses INT_MIN as the minimum contraint value.
This is a negative value and so fails the correctness check further
down.

> You might want to provide a different patch, but ignoring
> this regression doesn't seem practical...

The code that was being fixed was only even in -next for a relatively
brief period of time.

>  		/* else require explicit machine-level constraints */
> -		if (cmin <= 0 || cmax <= 0 || cmax < cmin) {
> +		else if (cmin <= 0 || cmax <= 0 || cmax < cmin) {

Yeah, a different patch I think.  I'll send one shortly.
