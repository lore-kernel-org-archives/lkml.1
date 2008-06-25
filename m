Return-Path: <linux-kernel-owner+w=401wt.eu-S1758724AbYFYQCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724AbYFYQCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbYFYQCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:02:43 -0400
Received: from ns1.suse.de ([195.135.220.2]:46000 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbYFYQCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:02:42 -0400
Date: Wed, 25 Jun 2008 18:03:19 +0200
From: Bernhard Walle <bwalle@suse.de>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
       kexec@lists.infradead.org
Subject: Re: [PATCH 3/3] Limit E820 map when a user-defined memory map is
 specified
Message-ID: <20080625180319.122819ea@halley.suse.de>
In-Reply-To: <86802c440806250901n68278ab1ma1add38c165122af@mail.gmail.com>
References: <1214395342-20375-1-git-send-email-bwalle@suse.de>
	<1214395342-20375-4-git-send-email-bwalle@suse.de>
	<86802c440806250901n68278ab1ma1add38c165122af@mail.gmail.com>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
X-Face: ,G!z)dEOMkc[Cu+sF64,T9^5r3b>/}#HBRL%D^j@\SZbr'Itl7q@1<*dgB?A7(_leO1Tc4^
 D*WfvfwKcz;,@E^y+pNP%86n8o<&g-vToCXW:r>Y$jxY,`KT?{H!07=2|Jdt?0ba^C-Tnx50vIV8It
 vi&Sicl:sj`k2`y)E;ECFi;i7W-?t3%\kD*));q)+%-pQd^.r'W}oBBx=+.~Gu}&F;lS7.a-m>Rv"w
 pe`D'OV^?HJd$-)7<2T[naDPl6+bAj'+UYd]u]B^'.LYK$2jS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yinghai Lu [2008-06-25 09:01]:
> On Wed, Jun 25, 2008 at 5:02 AM, Bernhard Walle <bwalle@suse.de> wrote:
> >  }
> >  early_param("mem", parse_memopt);
> > @@ -1023,6 +1025,7 @@ static int __init parse_memmap_opt(char *p)
> >                e820_add_region(start_at, mem_size, E820_RESERVED);
> >        } else {
> >                end_user_pfn = (mem_size >> PAGE_SHIFT);
> > +               e820_update_range(mem_size, ULLONG_MAX, E820_RAM, E820_RESERVED);
> >        }
> >        return *p == '\0' ? 0 : -EINVAL;
> >  }
> > --
> 
> only this one is needed now. but please change ULLONG_MAX to
> ULLONG_MAX - mem_size

Why can't we add that check at the beginning of e820_update_range() as
you suggested?


Bernhard
