Return-Path: <linux-kernel-owner+w=401wt.eu-S932223Ab0AEV1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab0AEV1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 16:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932154Ab0AEV1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 16:27:21 -0500
Received: from cantor.suse.de ([195.135.220.2]:42608 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452Ab0AEV1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 16:27:09 -0500
Date: Tue, 5 Jan 2010 13:21:41 -0800
From: Greg KH <gregkh@suse.de>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [32/39] rt2x00: Disable powersaving for rt61pci and rt2800pci.
Message-ID: <20100105212141.GB32235@suse.de>
References: <20100105200303.142938701@mini.kroah.org>
 <4B43A82B.6010103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B43A82B.6010103@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 09:59:23PM +0100, Gertjan van Wingerde wrote:
> On 01/05/10 21:02, Greg KH wrote:
> > 2.6.31-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Gertjan van Wingerde <gwingerde@gmail.com>
> > 
> > commit 93b6bd26b74efe46b4579592560f9f1cb7b61994 upstream.
> > 
> > We've had many reports of rt61pci failures with powersaving enabled.
> > Therefore, as a stop-gap measure, disable powersaving of the rt61pci
> > until we have found a proper solution.
> > Also disable powersaving on rt2800pci as it most probably will show
> > the same problem.
> > 
> > Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> > Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > ---
> >  drivers/net/wireless/rt2x00/rt61pci.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > --- a/drivers/net/wireless/rt2x00/rt61pci.c
> > +++ b/drivers/net/wireless/rt2x00/rt61pci.c
> > @@ -2546,6 +2546,11 @@ static int rt61pci_probe_hw_mode(struct 
> >  	unsigned int i;
> >  
> >  	/*
> > +	 * Disable powersaving as default.
> > +	 */
> > +	rt2x00dev->hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
> > +
> > +	/*
> >  	 * Initialize all hw fields.
> >  	 */
> >  	rt2x00dev->hw->flags =
> > 
> > 
> > 
> 
> Same as for .32-stable. An updated patch (as sent by John Linville) is
> needed to compile correctly.

Ick, sorry about that, I've fixed up the .31 patch, will go fix up the
.32 patch now as well.

thanks,

greg k-h
