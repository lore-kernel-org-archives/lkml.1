Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479Ab0AEV1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab0AEV1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 16:27:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755325Ab0AEV1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 16:27:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34769 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755148Ab0AEV1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 16:27:07 -0500
Date: Tue, 5 Jan 2010 13:21:22 -0800
From: Greg KH <gregkh@suse.de>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [08/10] rt2x00: Disable powersaving for rt61pci and rt2800pci.
Message-ID: <20100105212122.GA32235@suse.de>
References: <20100105194915.239350321@mini.kroah.org>
 <4B43A7EF.8040702@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B43A7EF.8040702@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 09:58:23PM +0100, Gertjan van Wingerde wrote:
> On 01/05/10 20:47, Greg KH wrote:
> > 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
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
> > @@ -2281,6 +2281,11 @@ static void rt61pci_probe_hw_mode(struct
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
> This one isn't applicable for .27. Powersaving wasn't implemented on .27 yet, so
> this patch is unnecessary, and won't compile on .27.

Thanks, I've now dropped it.

greg k-h
