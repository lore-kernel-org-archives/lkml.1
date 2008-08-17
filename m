Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbYHQI7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbYHQI7f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 04:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbYHQI7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 04:59:07 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:26040 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbYHQI7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 04:59:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=aSY2+qKrs2XYcUckhtH8gYZ4kwe/5TZZvmlbJixfKtx+v3j4ExbQxcvWbf007gSgqA
         bqEEf0+zeW2rPI/+7yfcfLXNoSpseV+YDq1QapgDkRvnopR+nMKwUjoQDjtNENvgGrB5
         xKWH5vY/EgpYq3PyUb3ltHmDUb5v+L21xvmSA=
To: Greg KH <greg@kroah.com>
Subject: Re: [stable] Fixing rt2500pci [PATCH]
Date: Sun, 17 Aug 2008 10:58:56 +0200
User-Agent: KMail/1.9.9
Cc: John Linville <linville@tuxdriver.com>, stable@kernel.org,
       linux-wireless@vger.kernel.org, Peter Chubb <peterc@gelato.unsw.edu.au>,
       linux-kernel@vger.kernel.org
References: <87tze8vu18.wl%peterc@chubb.wattle.id.au> <200808121201.26544.IvDoorn@gmail.com> <20080816233249.GA9714@kroah.com>
In-Reply-To: <20080816233249.GA9714@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808171058.56532.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 August 2008, Greg KH wrote:
> On Tue, Aug 12, 2008 at 12:01:26PM +0200, Ivo van Doorn wrote:
> > On Thursday 31 July 2008, Peter Chubb wrote:
> > > 
> > > In kernel version 2.6.26-rc9 my wireless LAN card worked; but in the
> > > released 2.6.26, my RaLink rt2500 card wouldn't associate.
> > > 
> > > Git-bisect led me to this patch:
> > > 
> > > 	61486e0f68d1f8966c09b734566a187d42d65c54
> > > 	rt2x00: Remove ieee80211_tx_control argument from write_tx_desc()
> > > 
> > > I believe that there is a problem with that patch --- it
> > > (inadvertantly) removes an extra line of code, that used to set the
> > > DATABYTE_COUNT field.
> > >  
> > > This patch reinstates that line, and with it my card works again.
> > >  
> > > Signed-off-by: Peter Chubb <peterc@gelato.unsw.edu.au>
> > > Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
> > 
> > [stable@kernel.org added to CC]
> > 
> > The 2.6.27 version of the patch has already been pushed upstream,
> > this one is for 2.6.26-stable since this fixes a regression introduced after 2.6.25.
> 
> Are you sure?  Looking at 2.6.26, the code in that function looks like
> it is properly setting the TXD_W0_DATABYTE_COUNT, field.
> 
> If it's really a problem, can you send stable@kernel.org a patch that
> applies to 2.6.26.2?

Hmm, that is weird, that line is indeed present, which means that the
commit which was responsible for the breakage wasn't in 2.6.26.
I guess peter tested a git checkout from after 2.6.26 or something. :S

Ivo

