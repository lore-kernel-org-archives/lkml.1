Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbYA3AfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbYA3AfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 19:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbYA3Aex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 19:34:53 -0500
Received: from andromeda.dapyr.net ([206.212.254.10]:51356 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbYA3Aev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 19:34:51 -0500
From: Konrad Rzeszutek <konrad@darnok.org>
To: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] Add iSCSI IBFT support (v0.4.5) - fixes to the header files.
Date: Tue, 29 Jan 2008 19:32:29 -0500
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, dwm@enoyolf.org, darnok@68k.org,
       pjones@redhat.com, konradr@redhat.com, konradr@linux.vnet.ibm.com,
       randy.dunlap@oracle.com, hpa@zytor.com, lenb@kernel.org,
       mike.anderson@us.ibm.com, dwm@austin.ibm.com, arjan@infradead.org,
       Andy Whitcroft <apw@shadowen.org>,
       James.Bottomley@hansenpartnership.com
References: <20080128185503.GA3930@andromeda.dapyr.net> <479F7B43.6090801@cs.wisc.edu>
In-Reply-To: <479F7B43.6090801@cs.wisc.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801291932.31912.konrad@darnok.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2008 14:15:15 Mike Christie wrote:
> Konrad Rzeszutek wrote:
> > +/*
> > + * Helper functions to parse data properly.
> > + */
> > +static ssize_t sprintf_ipaddr(char *buf, u8 *ip)
> > +{
> > +	if (ip[0] == 0 && ip[1] == 0 && ip[2] == 0 && ip[3] == 0 &&
> > +	    ip[4] == 0 && ip[5] == 0 && ip[6] == 0 && ip[7] == 0 &&
> > +	    ip[8] == 0 && ip[9] == 0 && ip[10] == 0xff && ip[11] == 0xff) {
> > +		/*
> > +		 * IPV4
> > +		 */
> > +		return sprintf(buf, "%d.%d.%d.%d\n", ip[12],
> > +			       ip[13], ip[14], ip[15]);
> > +	} else
> > +		return 0;
> > +}
>
> You probably just want to use the NIPQUAD_FMT and NIP6_FMT macros here.

Ah, I knew a macro like this _ought_ to be there somewhere. Thanks.

> Also why isn't ipv6 supported?

I didn't get to test the IPV6  yet so I didn't want to put in code that might 
have worked or not :-(

