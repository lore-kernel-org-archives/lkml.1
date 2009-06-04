Return-Path: <linux-kernel-owner+w=401wt.eu-S1754509AbZFDER6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbZFDER6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 00:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbZFDERu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 00:17:50 -0400
Received: from bhuna.collabora.co.uk ([93.93.131.97]:58612 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbZFDERu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 00:17:50 -0400
Date: Thu, 4 Jun 2009 00:17:40 -0400
From: Andres Salomon <dilinger@collabora.co.uk>
To: Paul Fox <pgf@laptop.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, dsaxena@laptop.org
Subject: Re: [PATCH] forced recalibration for the OLPC hgpk touchpad
Message-ID: <20090604001740.490f747e@mycelium.queued.net>
In-Reply-To: <19417.1244087913@foxharp.boston.ma.us>
References: <3026.1243972079@foxharp.boston.ma.us>
	<200906030804.57340.dmitry.torokhov@gmail.com>
	<19417.1244087913@foxharp.boston.ma.us>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Jun 2009 23:58:33 -0400
Paul Fox <pgf@laptop.org> wrote:

> dmitry wrote:
>  > Hi Paul,
>  > 
>  > On Tuesday 02 June 2009 12:47:59 pgf@laptop.org wrote:
>  > > The OLPC XO laptop incorporates a combination touchpad/tablet
>  > > device which unfortunately requires frequent recalibration.  The
>  > > driver will force this automatically when various suspicious
>  > > behaviors are observed, and the user can recalibrate manually
>  > > (with a special keyboard sequence).  There's currently no way,
>  > > however, for an external program to cause recalibration.
>  > >
>  > > This patch creates a new node in /sys which, when written with
>  > > '1', will force a touchpad recalibration.  No other writes (or
>  > > reads) of this node are supported.
>  > >
>  > 
>  > 
>  > Instead of creating a new sysfs attribute maybe we should make
>  > the touchpad recalibrate upon resume (reconnect)? Userspace can
>  > already request reconnect via sysfs.
> 
> dmitry -- thanks for the suggestion.
> 
> i took a look, and tried it.  the problem is that doing a full
> reset of the touchpad takes quite a long time -- 1.1 or 1.2
> seconds.  recalibration deprives the user of their touchpad for
> long enough as it is -- i don't think we can afford that time.
> (remember that this is a workaround for bad hardware -- the XO
> no longer uses this touchpad at least partly due to this very
> issue, but there are enough in use that we're still trying to
> improve things.)
> 

I do like the idea of having a sysfs trigger for recalibrations.  We've
never been successful in having the kernel driver handle recalibrations
seamlessly.  Perhaps touchpad hardware screwups would be easier to
detect in userspace, given a daemon that can keep a history of the last
N touchpad coordinates?
