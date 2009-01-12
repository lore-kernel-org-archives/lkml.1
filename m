Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbZALONa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbZALONa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 09:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbZALONU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 09:13:20 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:41328 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbZALONU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 09:13:20 -0500
Date: Mon, 12 Jan 2009 15:14:57 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: wrong usage of __devexit_p and __exit_p
Message-ID: <20090112141457.GA11777@uranus.ravnborg.org>
References: <20090112135057.GA10250@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090112135057.GA10250@pengutronix.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 02:50:57PM +0100, Uwe Kleine-König wrote:
> Hello,
> 
> I found several drivers that use __devexit_p and __exit_p on functions
> that don't live in .devexit.text or .exit.text resp.
> 
> The impact is either that these functions use memory without being used
> or that they don't link.
> 
> I send 24 patches as a reply to this mail.  I choosed to move the
> functions into the respective function instead of using the right
> __{dev,}exit_p wrapper because it seems to me to have less impact.
> 
> I didn't made the effort to find out the right people to Cc: but I hope
> that Andrew takes care of that :-)

Did you check that this did not introduce any new Section mismatch warnings?
We have seen several __exit annotated functions that was used from __init
annotated code or even from normal code.
Thus the __exit annotation was wrong in these cases.

	Sam
