Return-Path: <linux-kernel-owner+w=401wt.eu-S934323AbZKXWnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934323AbZKXWnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 17:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934264AbZKXWnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 17:43:50 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49762 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933965AbZKXWnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 17:43:49 -0500
Subject: Re: [PATCH 05/10] kbuild: sort the list of symbols exported by the
 kernel (__ksymtab)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Alex Chiang <achiang@hp.com>,
       Tony Luck <tony.luck@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Mike Frysinger <vapier.adi@gmail.com>, greg@kroah.com,
       linux-kbuild@vger.kernel.org, carmelo73@gmail.com,
       linux-kernel@vger.kernel.org, kyle@mcmartin.ca, deller@gmx.de,
       jejb@parisc-linux.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, paulus@samba.org
In-Reply-To: <4B0BA725.2050604@tuffmail.co.uk>
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com>
	 <4B072E31.4000906@tuffmail.co.uk> <20091123195320.GD26810@ldl.fc.hp.com>
	 <200911241127.18013.rusty@rustcorp.com.au>
	 <1259041182.2433.945.camel@mulgrave.site> <4B0BA725.2050604@tuffmail.co.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Nov 2009 16:43:49 -0600
Message-Id: <1259102629.4549.842.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 09:28 +0000, Alan Jenkins wrote:
> James Bottomley wrote:
> > On Tue, 2009-11-24 at 11:27 +1030, Rusty Russell wrote:
> >   
> >> On Tue, 24 Nov 2009 06:23:20 am Alex Chiang wrote:
> >>     
> >>> Hi Alan, Rusty,
> >>>       
> >> Hi Alex,
> >>
> >>     
> >>> In the meantime, while Alan is deciding the proper way to fix
> >>> this, would it be possible to drop the offending patch series
> >>> from linux-next?
> >>>       
> >> Done.  That takes the pressure off Alan, and makes sure he has time to get
> >> it right.
> >>     
> >
> > That probably suits us on parisc too.  I just checked out our build in
> > linux-next: we don't pass __modpost ... it looks like we have all the
> > module symbols undefined.  Will investigate more.
> >
> > James
> >   
> 
> I think parisc wants P'printk where ia64 uses @fptr(printk).
> 
> It may also need ".import printk,code" or similar.

I think if you have to make modpost architecture specific, there's
something a bit wrong in the patch series.

I can confirm that reverting this particular patch allows the parisc
build to work again.  It still won't boot because module symbols aren't
resolved.

James


