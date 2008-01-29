Return-Path: <linux-kernel-owner+w=401wt.eu-S1765867AbYA2Tgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765867AbYA2Tgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 14:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756728AbYA2TgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 14:36:11 -0500
Received: from sabe.cs.wisc.edu ([128.105.6.20]:38893 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbYA2TgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 14:36:09 -0500
Message-ID: <479F7B43.6090801@cs.wisc.edu>
Date: Tue, 29 Jan 2008 13:15:15 -0600
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Konrad Rzeszutek <konrad@darnok.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, dwm@enoyolf.org, darnok@68k.org,
       pjones@redhat.com, konradr@redhat.com, konradr@linux.vnet.ibm.com,
       randy.dunlap@oracle.com, hpa@zytor.com, lenb@kernel.org,
       mike.anderson@us.ibm.com, dwm@austin.ibm.com, arjan@infradead.org,
       Andy Whitcroft <apw@shadowen.org>,
       James.Bottomley@hansenpartnership.com
Subject: Re: [PATCH] Add iSCSI IBFT support (v0.4.5) - fixes to the header
 files.
References: <20080128185503.GA3930@andromeda.dapyr.net>
In-Reply-To: <20080128185503.GA3930@andromeda.dapyr.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek wrote:
> +/*
> + * Helper functions to parse data properly.
> + */
> +static ssize_t sprintf_ipaddr(char *buf, u8 *ip)
> +{
> +	if (ip[0] == 0 && ip[1] == 0 && ip[2] == 0 && ip[3] == 0 &&
> +	    ip[4] == 0 && ip[5] == 0 && ip[6] == 0 && ip[7] == 0 &&
> +	    ip[8] == 0 && ip[9] == 0 && ip[10] == 0xff && ip[11] == 0xff) {
> +		/*
> +		 * IPV4
> +		 */
> +		return sprintf(buf, "%d.%d.%d.%d\n", ip[12],
> +			       ip[13], ip[14], ip[15]);
> +	} else
> +		return 0;
> +}

You probably just want to use the NIPQUAD_FMT and NIP6_FMT macros here. 
Also why isn't ipv6 supported?
