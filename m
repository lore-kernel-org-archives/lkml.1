Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbZALOnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbZALOnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 09:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbZALOna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 09:43:30 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39286 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbZALOn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 09:43:29 -0500
Date: Mon, 12 Jan 2009 15:43:27 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: wrong usage of __devexit_p and __exit_p
Message-ID: <20090112144327.GB29183@pengutronix.de>
References: <20090112135057.GA10250@pengutronix.de> <20090112141457.GA11777@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090112141457.GA11777@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 03:14:57PM +0100, Sam Ravnborg wrote:
> On Mon, Jan 12, 2009 at 02:50:57PM +0100, Uwe Kleine-König wrote:
> > Hello,
> > 
> > I found several drivers that use __devexit_p and __exit_p on functions
> > that don't live in .devexit.text or .exit.text resp.
> > 
> > The impact is either that these functions use memory without being used
> > or that they don't link.
> > 
> > I send 24 patches as a reply to this mail.  I choosed to move the
> > functions into the respective function instead of using the right
> > __{dev,}exit_p wrapper because it seems to me to have less impact.
> > 
> > I didn't made the effort to find out the right people to Cc: but I hope
> > that Andrew takes care of that :-)
> 
> Did you check that this did not introduce any new Section mismatch warnings?
> We have seen several __exit annotated functions that was used from __init
> annotated code or even from normal code.
> Thus the __exit annotation was wrong in these cases.
I wrote in the commit logs, that the functions are only used as argument
to __{dev,}exit_p.  There are no direct calls. (IIRC there was only one
exception that I checked manually.)

I think the __{dev,}exit_p wrappers are only used to define remove
callbacks, so there should be no harm.

Best regards and thanks for your feedback,
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
Peiner Strasse 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686              | Fax:   +49-5121-206917-5555 |
