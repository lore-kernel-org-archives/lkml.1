Return-Path: <linux-kernel-owner+w=401wt.eu-S1758154AbYCaVBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbYCaVBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 17:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756812AbYCaVBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 17:01:38 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44942 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755427AbYCaVBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 17:01:37 -0400
Date: Mon, 31 Mar 2008 14:01:35 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 1/2] Define sysfs interfaces for ibmaem driver
Message-ID: <20080331210135.GC7183@tree.beaverton.ibm.com>
References: <20080328213646.GC7191@tree.beaverton.ibm.com> <20080329145603.7e47418f@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080329145603.7e47418f@hyperion.delvare>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2008 at 02:56:03PM +0100, Jean Delvare wrote:
> > +energy[1-*]_input		Instantaneous energy use
> 
> This doesn't make sense to me. Energy is a quantity, it exists
> independently of time. An "instantaneous energy use" only makes sense
> if you tell in what (presumably very small) amount of time the energy
> was used... and then what you are measuring is not an energy but a
> power, for which we already have an interface. Please clarify.

Wes Felter suggested "Cumulative energy use", and I'll go with that.

> > +power[1-*]_interval		Power use averaging interval
> 
> Wouldn't power[1-*]_average_interval be clearer?

Given that power is energy used over a period of time, I wonder if it
might be more accurate to remove powerX_input and leave this name alone.
That said, it does seem to be the case that interval names take the
format "${sensorfile}_interval", so I suppose it makes more sense the
way that you suggest.

> > +				Unit: milliseconds
> 
> Nitpicking for consistency: millisecond (no trailing s).
> 
> What values do you expect for this entry? I am wondering if it's safe
> to use millisecond as a unit. Is it unlikely that a future chip will
> support averaging intervals below the millisecond?

It's possible that a future chip could do this, though today we only
support intervals in the hundreds of milliseconds.  The default for the
ibmaem driver is currently 1s.

--D
