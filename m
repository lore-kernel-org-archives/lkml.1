Return-Path: <linux-kernel-owner+w=401wt.eu-S1759780AbZD2TXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759780AbZD2TXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756554AbZD2TXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:23:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54621 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271AbZD2TXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:23:41 -0400
Date: Wed, 29 Apr 2009 21:23:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: borislav.petkov@amd.com, greg@kroah.com, tglx@linutronix.de, hpa@zytor.com,
       dougthompson@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/21] amd64_edac: add f10-and-later methods-p3
Message-ID: <20090429192326.GA14652@elte.hu>
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com> <1241024107-14535-14-git-send-email-borislav.petkov@amd.com> <20090429182255.GD8321@elte.hu> <20090429120501.ae005dc4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429120501.ae005dc4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 29 Apr 2009 20:22:55 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > +		InputAddr = ChannelAddrLong >> 8;
> > > +
> > > +		debugf1("   (ChannelAddrLong=0x%llx) >> 8 becomes "
> > > +			"InputAddr=0x%x\n", ChannelAddrLong, InputAddr);
> > > +
> > > +		/* Iterate over the DRAM DCTs looking for a
> > > +		 * match for InputAddr on the selected NodeID
> > > +		 */
> > > +		CSFound = f10_lookup_addr_in_dct(InputAddr,
> > > +						NodeID, ChannelSelect);
> > > +
> > > +		if (CSFound >= 0) {
> > > +			*node_id = NodeID;
> > > +			*channel_select = ChannelSelect;
> > > +		}
> > > +	}
> > > +
> > > +	return CSFound;
> > > +}
> > 
> > this function is probably too large, and also it uses some weird 
> > hungarian notation coding style. Please dont do that! It's 
> > completely unacceptable.
> 
> These identifers (or at least, DctSelBaseOffsetLong, which is the 
> only one I googled for) come straight out of the AMD "BIOS and 
> Kernel Developer's Guide".
> 
> Sucky though they are, there's value in making the kernel code 
> match up with the documentation.

I'm generally resisting patches that hungarinize arch/x86/ (and heck 
there's been many attempts ...) but there's some conflicting advice 
here. I've Cc:-ed Linus, maybe he has an opinion about this.

My gut reaction would be 'hell no'. There's other, structural 
problems with this code too, and doing some saner naming would 
mostly be a sed job and would take minimal amount of time. The 
naming can still be intuitive. The symbols from the documentation 
can perhaps be mentioned in a couple of comments to establish a 
mapping.

	Ingo
