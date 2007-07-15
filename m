Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbXGOEwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbXGOEwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 00:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbXGOEwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 00:52:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53660 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751109AbXGOEwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 00:52:04 -0400
Date: Sat, 14 Jul 2007 21:51:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dougthompson@xmission.com
Cc: Doug Thompson <norsk5@yahoo.com>, greg@kroah.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, Egor Martovetsky <egor@pasemi.com>
Subject: Re: [PATCH 3/8] drivers edac new pasemi driver
Message-Id: <20070714215152.bb5a440f.akpm@linux-foundation.org>
In-Reply-To: <20070715001245.32242.qmail@web50109.mail.re2.yahoo.com>
References: <20070713113641.52157b67.akpm@linux-foundation.org>
	<20070715001245.32242.qmail@web50109.mail.re2.yahoo.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jul 2007 17:12:45 -0700 (PDT) Doug Thompson <norsk5@yahoo.com> wrote:

> 
> --- Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> 
> > > +		default:
> > > +			edac_mc_printk(mci, KERN_ERR,
> > > +				       "Unrecognized Rank Config\n");
> > 
> > If this message ever comes out, you're gonna say "argh, I wish I'd printed
> > rankcfg".
> > 
> > Do you want to do this??
> 
> Yeah, I will gen a patch for him. He is in india and turn around takes a day or two
> 

Confused.  I already did the patch, below.  

> 
> 
> 
> > 
> > --- a/drivers/edac/pasemi_edac.c~drivers-edac-new-pasemi-driver-fix
> > +++ a/drivers/edac/pasemi_edac.c
> > @@ -168,7 +168,8 @@ static int pasemi_edac_init_csrows(struc
> >  			break;
> >  		default:
> >  			edac_mc_printk(mci, KERN_ERR,
> > -				       "Unrecognized Rank Config\n");
> > +				"Unrecognized Rank Config. rankcfg=%u\n",
> > +				rankcfg);
> >  			return -EINVAL;
> >  		}
> >  
> > @@ -244,9 +245,8 @@ static int __devinit pasemi_edac_probe(s
> >  	 */
> >  	pasemi_edac_get_error_info(mci);
> >  
> > -	if (edac_mc_add_mc(mci, system_mmc_id++)) {
> > +	if (edac_mc_add_mc(mci, system_mmc_id++))
> >  		goto fail;
> > -	}
> >  
> >  	/* get this far and it's successful */
> >  	return 0;
> > _
> > 
> > 
