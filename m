Return-Path: <linux-kernel-owner+w=401wt.eu-S1422733AbXBAKHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422733AbXBAKHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 05:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422735AbXBAKHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 05:07:34 -0500
Received: from mathups.math.u-psud.fr ([129.175.52.4]:34137 "EHLO
	matups.math.u-psud.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1422733AbXBAKHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 05:07:33 -0500
X-Greylist: delayed 942 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Feb 2007 05:07:32 EST
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 3/3] cxacru: Store all device status information and report it when atm_proc_read is called.
Date: Thu, 1 Feb 2007 10:15:31 +0100
User-Agent: KMail/1.9.6
References: <45BFB8F5.5010607@simon.arlott.org.uk> <20070131153914.eb693314.akpm@osdl.org>
In-Reply-To: <20070131153914.eb693314.akpm@osdl.org>
Cc: Simon Arlott <simon@arlott.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702011015.32238.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 1 February 2007 00:39:14 you wrote:
> On Tue, 30 Jan 2007 21:30:29 +0000
> Simon Arlott <simon@arlott.org> wrote:
> 
> > +static int cxacru_proc_read(struct usbatm_data *usbatm_instance,
> > +	struct atm_dev *atm_dev, loff_t * pos, char *page)
> > +{
> > +	struct cxacru_data *instance = usbatm_instance->driver_data;
> > +	u32 *cxinf = instance->cxinf_status;
> > +	int left = *pos;
> > +
> > +	if (!left--)
> > +		return sprintf(page, "# %s\n", usbatm_instance->description);
> > +
> > +	if (!left--) {
> > +		if (cxinf[CXINF_LINE_STATUS] == 5) {
> > +			return sprintf(page, "# UP %u/%u\n",
> > +				cxinf[CXINF_DOWNSTREAM_RATE],
> > +				cxinf[CXINF_UPSTREAM_RATE]);
> > +		} else {
> > +			return sprintf(page, "# DOWN\n");
> > +		}
> > +	}
> 
> hm, how well-tested was this proc interface?  The pread() and lseek()
> behaviour might be strange.
> 
> I guess as long as it doesn't oops, hang or anything like that then it'll
> be OK.  Anyone who does anything apart from a single big-fat-read from a 
> procfile has a good chance of getting into trouble :(

All the ATM drivers seem to do it like this.  That doesn't mean they are
right of course!  But I never saw anyone complain on the ATM mailing list.
On the other hand, why does Simon want this?  If he has written a user space
tool that extracts bits from the proc file (eg: to tell users what's going
on) then he could run into trouble, depending on how he implements it.

Ciao,

Duncan.
