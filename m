Return-Path: <linux-kernel-owner+w=401wt.eu-S932737AbYA2Nle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737AbYA2Nle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 08:41:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933126AbYA2NkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 08:40:18 -0500
Received: from styx.suse.cz ([82.119.242.94]:55426 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764014AbYA2NkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:40:14 -0500
From: David Sterba <dsterba@suse.cz>
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] ipwireless: driver for 3G PC Card
Date: Tue, 29 Jan 2008 14:40:05 +0100
User-Agent: KMail/1.9.6 (enterprise 20071221.751182)
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jkosina@suse.cz, benm@symmetric.co.nz, stephen@symmetric.co.nz
References: <20080128171929.GA3906@ds.suse.cz> <20080128100854.fe7acad8.rdunlap@xenotime.net>
In-Reply-To: <20080128100854.fe7acad8.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801291440.06099.dsterba@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 of January 2008 19:08:54 Randy Dunlap wrote:

> > +/* Number of bytes in NL packet header (can not do
>
> cannot

Fixed.

>
> > + * sizeof(nl_packet_header) since it's a bitfield) */
> > +#define NL_FOLLOWING_PACKET_HEADER_SIZE    1
> > +
> > +struct nl_first_paket_header {
>
>                    packet ?

Yes, packet of course.

>
> > +#if defined(__BIG_ENDIAN)
> > +	unsigned char packet_rank:2;
> > +	unsigned char address:3;
> > +	unsigned char protocol:3;
> > +#else
> > +	unsigned char protocol:3;
> > +	unsigned char address:3;
> > +	unsigned char packet_rank:2;
> > +#endif
>
> From C99 spec:
> "The order of allocation of bit-fields within a unit (high-order to
> low-order or low-order to high-order) is implementation-defined."
>
> so if the order/location of these bitfields is important (from one
> system to another), you should use bit masks instead of bitfields
> for them.

I've changed it to __BIG_ENDIAN_BITFIELDS, as suggested by Alexey. The order 
is important. I'll add it to my todo to convert it to bitmasks.

> > +/*
> > + * @return 1 if something has been received from hw
>
> What's with the '@'?

Removed, and converted to plaintext as suggested by others.

> Need ":" and/or space between CARD_NAME and following string.
> (in several places)

Found a few of them and fixed.

> > +module_param(major, int, 0);
> > +module_param(ipwireless_debug, int, 0);
> > +module_param(ipwireless_loopback, int, 0);
> > +module_param(ipwireless_out_queue, int, 0);
> > +MODULE_PARM_DESC(major, "ttyIPWp major number [0]");
> > +MODULE_PARM_DESC(ipwireless_debug, "switch on debug messages [0]");
> > +MODULE_PARM_DESC(ipwireless_debug, "switch on loopback mode [0]");
> > +MODULE_PARM_DESC(ipwireless_debug, "set size of outgoing queue [1]");
>
> Will these parameters be documented anywhere?

The options are intended for debugging. Normal user does not need to tweak 
them. Adjusted the description to reflect their debugging purpose.

> > +#ifdef IPWIRELESS_STATE_DEBUG
> > +int ipwireless_dump_network_state(char *p, struct ipw_network *network)
> > +{
> > +	int idx = 0;
> > +
> > +	idx += sprintf(p + idx, "debug: ppp_blocked=%d\n",
> > +			network->ppp_blocked);
> > +	idx += sprintf(p + idx, "debug: outgoing_packets_queued=%d\n",
> > +			network->outgoing_packets_queued);
> > +	idx += sprintf(p + idx, "debug: network.shutting_down=%d\n",
> > +			network->shutting_down);
>
> check for overflow of 'p'?

Converted to one snprintf too.

> > +/* Syncronous start-messages */
>
> 	Synchronous

Fixed.

Updated patch will follow.


Thank you for comments.

Dave

