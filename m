Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbYAOMVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbYAOMVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 07:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbYAOMV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 07:21:28 -0500
Received: from phoenix.clifford.at ([88.198.7.52]:51001 "EHLO
	phoenix.clifford.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbYAOMVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 07:21:22 -0500
Date: Tue, 15 Jan 2008 13:15:06 +0100
From: Clifford Wolf <clifford@clifford.at>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: rlim in proc/<pid>/status
Message-ID: <20080115121503.GA13573@clifford.at>
References: <20080115100631.GA13394@clifford.at> <20080115194321.119D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115194321.119D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 15, 2008 at 07:47:22PM +0900, KOSAKI Motohiro wrote:
> sound good for me.
> a few question please.
> 
> > +	for (i=0; i<RLIM_NLIMITS; i++) {
> > +		if (rlim_names[i])
> > +			buffer += sprintf(buffer, "Rlim%s:\t", rlim_names[i]);
> > +		else
> > +			buffer += sprintf(buffer, "Rlim%d:\t", i);
> 
> this else is really necessary?

no. not with the current sources. maybe something like the following would
be better:

#if RLIM_NLIMITS != 15
#  error New RLIM_NLIMITS add mising entries to rlim_names[]
#endif

> > +		if (rlim[i].rlim_cur != ~0)
> > +			buffer += sprintf(buffer, "%lu\t", rlim[i].rlim_cur);
> > +		else
> > +			buffer += sprintf(buffer, "-\t");
> > +		if (rlim[i].rlim_max != ~0)
> > +			buffer += sprintf(buffer, "%lu\n", rlim[i].rlim_max);
> > +		else
> > +			buffer += sprintf(buffer, "-\n");
> 
> Why do you don't use RLIM_INFINITY?

because I'm blind and didn't see it... ;-)

maybe it would also be better to output 'inf' instead of '-' in this case?

yours,
 - clifford

-- 
The number of the beast - vi vi vi.
