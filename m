Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbYIRRdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbYIRRdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 13:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbYIRRdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 13:33:08 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:10441 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbYIRRdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 13:33:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=fuaqRnIA5Lnbe3M/eJ02Z7v+jpQ/hwEDRLd7n38rL6+xsuQaLPz8frVmqcJ/LeOtXy
         uGH9EYpmS2SrkuQHL+RTrguiEJcpVnYo/LK6GvVfAiiK6uRk0R+WAcTOboFA11fZTbkz
         8ZNGYJw0kb9gFx95YYwqwVXAZNTRcPGLxigoc=
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] rfkill: clarify usage of rfkill_force_state() and rfkill->get_state()
Date: Thu, 18 Sep 2008 19:32:58 +0200
User-Agent: KMail/1.9.9
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       John Linville <linville@tuxdriver.com>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>
References: <20080918145236.GJ1583@khazad-dum.debian.net> <20080918164339.GM1583@khazad-dum.debian.net> <1221756339.9262.86.camel@johannes.berg>
In-Reply-To: <1221756339.9262.86.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809181932.58272.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 September 2008, Johannes Berg wrote:
> On Thu, 2008-09-18 at 13:43 -0300, Henrique de Moraes Holschuh wrote:
> 
> > Now it must do something like this in pseudo-code:
> > 
> > 	1. if (the bit is disabled (i.e. SW rfkill is NOT ACTIVE)) {
> > 		rfkill-SW-status = disabled;
> > 	   }  else if (the bit is enabled (i.e. SW rfkill is ACTIVE)) {
> > 		if (tx power off is NOT ACTIVE)
> > 			rfkill-SW-status = enabled;
> > 		else
> > 			rfkill-SW-status = whatever the user asked
> > 	   }
> > 
> > THEN, it should use rfkill-sw-status, along with the hw rfkill line status,
> > to synthesize the state it must pass to rfkill_force_status().
> > 
> > ICK.  Of course, if the driver has another way to implement txpower off that
> > does not clash with sw rfkill, the above is unneeded.
> 
> Why are we not handling soft-rfkill in mac80211 entirely?

Ideal situation would indeed be that mac80211 registers a rfkill structure
and listens to rfkill events. This would help drivers by only needing to
register a rfkill structure for state-change events without any need for
listeners.

I was considering such a patch some time ago, but needed to figure out
how to work with the state-override capabilities (HW_BLOCK and SOFT_BLOCK)
and didn't work on it any further since.

Ivo
