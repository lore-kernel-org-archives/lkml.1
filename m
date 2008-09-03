Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbYICUCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbYICUCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 16:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbYICUCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 16:02:11 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:62445 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbYICUCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 16:02:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RhKDFE6bY8rqG43lh6P48hMRkgW9tkDQBwuRVZ6No5cnWphu91gEfPfQUUZ3njKVJm
         q+aqPcxmmLJ3JX3UlGrl+xRKrvXRVYa4+JaeSGZtjXutoQ8TIgV1MSBilx1Gn/4YucuO
         T6/zeMnsjpAdOTZODXI5LSGF6liNuoTRv9DaY=
Date: Wed, 3 Sep 2008 16:02:04 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: akpm@osdl.org, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcm5974-0.62: Compatibility mode reverted, BTN_TOUCH
	event added
Message-ID: <20080903160046.ZZRA012@mailhub.coreip.homeip.net>
References: <48BD9CA4.7080805@euromail.se> <20080902161432.ZZRA012@mailhub.coreip.homeip.net> <48BEEBA4.4050301@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48BEEBA4.4050301@euromail.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 09:55:16PM +0200, Henrik Rydberg wrote:
> Dmitry Torokhov wrote:
> > On Tue, Sep 02, 2008 at 10:05:56PM +0200, Henrik Rydberg wrote:
> >> @@ -296,6 +297,7 @@ static int report_tp_state(struct bcm5974 *dev, int size)
> >>
> >>  	input_report_abs(input, ABS_PRESSURE, int2bound(&c->p, p));
> >>
> >> +	input_report_key(input, BTN_TOUCH, p > 0);
> > 
> > Just relying on p will probably make it too sensitive, have you tried
> > adding hysteresis, like synaptics driver does?
> > 
> 
> I have, and the problem is somewhat more complicated when dealing with
> multiple fingers. The simple patch shown about actually works very well
> in practice. However, things can always improve. Yesterday I sent a
> second patch, bcm5974-0.63, which addressed this issue. However, the
> quality of the mouse movement has regressed a little in that patch.
> I would like to send yet another patch today, bcm5974-0.64, I hope this
> does not cause too much confusion.
> 

That is fine.

> Regarding mousedev, I noticed that the tap functionality does not distinguish
> between a tap (on/off localized in time and space) and a quick drag (on/off
> localized in time only).
> 

Yes. Mousedev is a stop-gap measure and is to be used only while user
installs proper driver. It does not need to be perfect.

-- 
Dmitry
