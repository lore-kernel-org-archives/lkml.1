Return-Path: <linux-kernel-owner+w=401wt.eu-S932247AbXBJOVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbXBJOVJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 09:21:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932257AbXBJOVI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 09:21:08 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:59278 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbXBJOVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 09:21:07 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <45CDD490.2020004@s5r6.in-berlin.de>
Date: Sat, 10 Feb 2007 15:20:00 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20070121 SeaMonkey/1.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Pieter Palmers <pieterp@joow.be>, Dan Dennedy <dan@dennedy.org>,
       linux1394-devel@lists.sourceforge.net
Subject: compat_ioctl (was [PATCH update] ieee1394: cycle timer read extension
 for raw1394/libraw1394)
References: <45BA5CFD.6070900@joow.be> <45BB27AF.7030007@s5r6.in-berlin.de> <45BB2D67.7030608@joow.be> <45BB4A33.4070206@s5r6.in-berlin.de> <tkrat.e06f68103e99e517@s5r6.in-berlin.de>
In-Reply-To: <tkrat.e06f68103e99e517@s5r6.in-berlin.de>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote on 2007-02-03:
> +#define RAW1394_IOC_GET_CYCLE_TIMER		\
> +	_IOR ('#', 0x30, struct raw1394_cycle_timer)
...
> +/* argument to RAW1394_IOC_GET_CYCLE_TIMER ioctl */
> +struct raw1394_cycle_timer {
> +	/* contents of Isochronous Cycle Timer register,
> +	   as in OHCI 1.1 clause 5.13 (also with non-OHCI hosts) */
> +	__u32 cycle_timer;
> +
> +	/* local time in microseconds since Epoch,
> +	   simultaneously read with cycle timer */
> +	__u64 local_time;
> +};
>  #endif /* IEEE1394_RAW1394_H */

Hmm, is this struct padded on 64bit platforms?
If so, would
	struct raw1394_cycle_timer {
		__u64 local_time;
		__u32 cycle_timer;
	};
be padded too?
-- 
Stefan Richter
-=====-=-=== --=- -=-=-
http://arcgraph.de/sr/
