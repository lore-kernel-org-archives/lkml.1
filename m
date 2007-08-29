Return-Path: <linux-kernel-owner+w=401wt.eu-S1758374AbXH2Sdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374AbXH2Sdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 14:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbXH2Sde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 14:33:34 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34470 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006AbXH2Sde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 14:33:34 -0400
Message-ID: <46D5BBFA.5060200@austin.ibm.com>
Date: Wed, 29 Aug 2007 13:33:30 -0500
From: jschopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Joachim Fenkes <fenkes@de.ibm.com>
CC: LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Thomas Klein <tklein@de.ibm.com>, Paul Mackerras <pmac@au1.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Nathan Lynch <ntl@pobox.com>
Subject: Re: [PATCH 2.6.23] ibmebus: Prevent bus_id collisions
References: <200708291815.18197.fenkes@de.ibm.com>
In-Reply-To: <200708291815.18197.fenkes@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +	len = strlen(dn->full_name + 1);
> +	bus_len = min(len, BUS_ID_SIZE - 1);
> +	memcpy(dev->ofdev.dev.bus_id, dn->full_name + 1
> +	       + (len - bus_len), bus_len);
> +	for (i = 0; i < bus_len; i++)
> +		if (dev->ofdev.dev.bus_id[i] == '/')
> +			dev->ofdev.dev.bus_id[i] = '_';
>  
>  	/* Register with generic device framework. */
>  	if (ibmebus_register_device_common(dev, dn->name) != 0) {

What happens when the full name is > 31 characters?  It looks to me that it 
will be truncated, which takes away the uniqueness guarantee.

There must be an individual property that is guaranteed to be unique and 
less than 32 characters.  How about "ibm,my-drc-index"?  That looks like a 
good candidate.
