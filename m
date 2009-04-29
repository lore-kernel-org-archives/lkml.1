Return-Path: <linux-kernel-owner+w=401wt.eu-S1754386AbZD2TJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbZD2TJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbZD2TJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:09:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753150AbZD2TJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:09:48 -0400
Date: Wed, 29 Apr 2009 12:05:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: borislav.petkov@amd.com, greg@kroah.com, tglx@linutronix.de, hpa@zytor.com,
       dougthompson@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/21] amd64_edac: add f10-and-later methods-p3
Message-Id: <20090429120501.ae005dc4.akpm@linux-foundation.org>
In-Reply-To: <20090429182255.GD8321@elte.hu>
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com>
	<1241024107-14535-14-git-send-email-borislav.petkov@amd.com>
	<20090429182255.GD8321@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009 20:22:55 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> > +		InputAddr = ChannelAddrLong >> 8;
> > +
> > +		debugf1("   (ChannelAddrLong=0x%llx) >> 8 becomes "
> > +			"InputAddr=0x%x\n", ChannelAddrLong, InputAddr);
> > +
> > +		/* Iterate over the DRAM DCTs looking for a
> > +		 * match for InputAddr on the selected NodeID
> > +		 */
> > +		CSFound = f10_lookup_addr_in_dct(InputAddr,
> > +						NodeID, ChannelSelect);
> > +
> > +		if (CSFound >= 0) {
> > +			*node_id = NodeID;
> > +			*channel_select = ChannelSelect;
> > +		}
> > +	}
> > +
> > +	return CSFound;
> > +}
> 
> this function is probably too large, and also it uses some weird 
> hungarian notation coding style. Please dont do that! It's 
> completely unacceptable.

These identifers (or at least, DctSelBaseOffsetLong, which is the only
one I googled for) come straight out of the AMD "BIOS and Kernel
Developer's Guide".

Sucky though they are, there's value in making the kernel code match up
with the documentation.

