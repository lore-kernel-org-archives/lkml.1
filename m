Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab0BSWDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 17:03:12 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:47969 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab0BSWDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 17:03:10 -0500
Date: Fri, 19 Feb 2010 22:03:06 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Allan, Bruce W" <bruce.w.allan@intel.com>
Cc: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [E1000-devel] [PATCH v3 1/2] e1000e: Only disable ASPM on
	82573L devices
Message-ID: <20100219220306.GA6795@srcf.ucam.org>
References: <1265912094-4705-1-git-send-email-mjg@redhat.com> <8DD2590731AB5D4C9DBF71A877482A9061394282@orsmsx509.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8DD2590731AB5D4C9DBF71A877482A9061394282@orsmsx509.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 19, 2010 at 01:53:01PM -0800, Allan, Bruce W wrote:

> Exactly which erratum are you referring to?  Erratum 17 in the 82573 
> Specification Update?  If that is the case, I see the possibility of 
> another interpretation of the erratum which suggests the possibility 
> of the same issue on other variants of the 82573 when using standard 
> frame sizes and ASPM enabled.  Not to mention, I believe there may be 
> other parts (82574 perhaps) that will have issues with L1 ASPM 
> enabled.  I will follow-up with the folks who did the investigation 
> that resulted in the erratum in order to get a clearer picture of all 
> this, and take a look into other parts that may likewise be affected.

Ah, yes - I see that it could be interpreted that way. The description 
seems to suggest that it's only relevant if ERT is enabled, which is 
required for jumbo frames. I'm not entirely clear on whether ERT is 
enabled in other circumstances? If not, we ought to be able to limit 
this to the L device - if not, it should be done on E and V as well.

The 82574 specification update doesn't mention any ASPM errata, but if 
you're able to check then that would be great. My main aim here is to 
try to get it turned back on on hardware where this works, since it's a 
measurable power saving.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
