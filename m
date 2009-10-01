Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbZJAJwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbZJAJwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 05:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756074AbZJAJwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 05:52:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38802 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072AbZJAJwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 05:52:06 -0400
Date: Thu, 1 Oct 2009 11:52:09 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 29/34] move virtballoon_remove to .devexit.text
Message-ID: <20091001095209.GB6386@pengutronix.de>
References: <20091001082607.GA2181@pengutronix.de> <1254385718-14254-29-git-send-email-u.kleine-koenig@pengutronix.de> <20091001093548.GH5718@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091001093548.GH5718@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Michael,

On Thu, Oct 01, 2009 at 11:35:48AM +0200, Michael S. Tsirkin wrote:
> On Thu, Oct 01, 2009 at 10:28:33AM +0200, Uwe Kleine-König wrote:
> > The function virtballoon_remove is used only wrapped by __devexit_p so
> > define it using __devexit.
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Acked-by: Sam Ravnborg <sam@ravnborg.org>
> > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > Cc: Michael S. Tsirkin <mst@redhat.com>
> > Cc: linux-kernel@vger.kernel.org
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Generally I think all remove pointers on virtio bus are devexit. 
That means I missed something?

>                                                                   How do
> you find all these,
I have a script that only generates few false-positives (and an unknown
number of false-negatives).

>                     and remember to mark new ones properly?
I don't understand that question.  You need to have understood how these
markings work and do it right.

>                                                              Can we
> annotate the remove pointer in struct virtio_driver so that sparse can
> find them?
I already thought about a runtime check.  I didn't implement anything
yet though.

I can give you my script that finds problems for platform_drivers.  You
should be able to adapt it for other types of drivers easily.  When most
platform_driver patches are in, I plan to look at pci.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
