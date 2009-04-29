Return-Path: <linux-kernel-owner+w=401wt.eu-S1758193AbZD2TpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193AbZD2TpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbZD2TpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:45:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48318 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751816AbZD2TpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:45:03 -0400
Date: Wed, 29 Apr 2009 12:42:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: torvalds@linux-foundation.org, borislav.petkov@amd.com, greg@kroah.com,
       tglx@linutronix.de, hpa@zytor.com, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/21] amd64_edac: add f10-and-later methods-p3
Message-Id: <20090429124228.8677d4eb.akpm@linux-foundation.org>
In-Reply-To: <20090429192326.GA14652@elte.hu>
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com>
	<1241024107-14535-14-git-send-email-borislav.petkov@amd.com>
	<20090429182255.GD8321@elte.hu>
	<20090429120501.ae005dc4.akpm@linux-foundation.org>
	<20090429192326.GA14652@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009 21:23:26 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> > > > +		if (CSFound >= 0) {
> > > > +			*node_id = NodeID;
> > > > +			*channel_select = ChannelSelect;
> > > > +		}
> > > > +	}
> > > > +
> > > > +	return CSFound;
> > > > +}
> > > 
> > > this function is probably too large, and also it uses some weird 
> > > hungarian notation coding style. Please dont do that! It's 
> > > completely unacceptable.
> > 
> > These identifers (or at least, DctSelBaseOffsetLong, which is the 
> > only one I googled for) come straight out of the AMD "BIOS and 
> > Kernel Developer's Guide".
> > 
> > Sucky though they are, there's value in making the kernel code 
> > match up with the documentation.
> 
> I'm generally resisting patches that hungarinize arch/x86/ (and heck 
> there's been many attempts ...) but there's some conflicting advice 
> here. I've Cc:-ed Linus, maybe he has an opinion about this.
> 
> My gut reaction would be 'hell no'. There's other, structural 
> problems with this code too, and doing some saner naming would 
> mostly be a sed job and would take minimal amount of time. The 
> naming can still be intuitive. The symbols from the documentation 
> can perhaps be mentioned in a couple of comments to establish a 
> mapping.

I think I disagree.  For those identifiers which map 1:1 with the
manufacturer's document, the ugliness involved in exactly copying the
manufacturer's chosen identifiers is outweighed by the benefit of
exactly copying the manufacturer's chosen identifiers.

Of course, we don't have to use StinkyIdentifiers anywhere else.  And
the nice thing about that is that when one reads the code and comes
across a StinkyIdentifier, one immeditely knows that it's an
AMD-provided thing rather than a Linux-provided thing.

Zillions of StinkyIdentifiers get merged via this logic.
