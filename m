Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752775AbYLQVeC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbYLQVeC (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 16:34:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYLQVdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 16:33:50 -0500
Received: from kroah.org ([198.145.64.141]:38888 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751396AbYLQVdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 16:33:49 -0500
Date: Wed, 17 Dec 2008 13:32:26 -0800
From: Greg KH <greg@kroah.com>
To: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Cc: Ben Dooks <ben-linux@fluff.org>, Julia Lawall <julia@diku.dk>,
        khali@linux-fr.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/28] drivers/ide: Drop return value from
	platform_driver remove functions
Message-ID: <20081217213226.GA26832@kroah.com>
References: <Pine.LNX.4.64.0812101727230.21998@ask.diku.dk> <20081216195734.GA8032@fluff.org.uk> <4948F56A.7020501@movial.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4948F56A.7020501@movial.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 02:49:46PM +0200, Dmitri Vorobiev wrote:
> Ben Dooks wrote:
> > On Wed, Dec 10, 2008 at 05:27:56PM +0100, Julia Lawall wrote:
> >> From: Julia Lawall <julia@diku.dk>
> >>
> >> The return value of the remove function of a driver structure, and thus of
> >> a platform_driver structure, is ultimately ignored, and is thus
> >> unnecessary.  This patch removes the return value for the remove function
> >> stored in a platform_driver structure.
> >>
> >> For the files drivers/i2c/busses/i2c-at91.c and
> >> drivers/i2c/busses/i2c-mv64xxx.c, the original return value was the value
> >> of a variable storing the result of calling i2c_del_adapter.  I have thus
> >> also deleted the declaration and initialization of this variable.  For the
> >> other files, the return values were always 0.
> >>
> >> A simplified version of the semantic patch that makes this change is as
> >> follows: (http://www.emn.fr/x-info/coccinelle/)
> > 
> > I take it remove_new will eventually be renamed to remove once all
> > the changes have been made?
> > 
> > Unless there are any objections I'll add this to the merge list for
> > the next window.
> 
> Please be careful since the drivers/base/ part has not been applied
> yet, so I'm Cc:ing Greg now for his opinion.

The more I think about it, the more I think it should not be changed,
sorry.  We should leave the return value and do something based on the
value of it if we can.

thanks,

greg k-h
