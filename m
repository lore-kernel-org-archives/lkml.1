Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbYFZRxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbYFZRxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 13:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbYFZRwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 13:52:50 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59933 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbYFZRwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 13:52:49 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4863D75F.3000804@s5r6.in-berlin.de>
Date: Thu, 26 Jun 2008 19:52:31 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080614 SeaMonkey/1.1.9
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH update] firewire: deadline for PHY config transmission
References: <tkrat.230a7a03785f244f@s5r6.in-berlin.de> <4858D304.80907@s5r6.in-berlin.de> <tkrat.9d09a78f5e399feb@s5r6.in-berlin.de>
In-Reply-To: <tkrat.9d09a78f5e399feb@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> +	long timeout = DIV_ROUND_UP(HZ, 10);
...
> +	card->driver->send_request(card, &p->packet);
> +	timeout = wait_for_completion_timeout(&p->done, timeout);
> +	kref_put(&p->kref, phy_packet_release);
>  
> -	card->driver->send_request(card, &p.packet);
> -	wait_for_completion(&p.done);
> +	/* will leak p if the callback is never executed */
> +	WARN_ON(timeout == 0);
>  }

I can easily trigger the WARN_ON with something like "printf 'br 
short\nbr short\nbr short\n' | firecontrol" (repeatedly done) on an 
otherwise well behaving FW323.  I will eventually look into changing the 
phy packet submission once more into something which cannot leak memory.
-- 
Stefan Richter
-=====-==--- -==- ==-=-
http://arcgraph.de/sr/
