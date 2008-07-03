Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbYGCHDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbYGCHDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbYGCG5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:57:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:60224 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468AbYGCBxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 21:53:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,741,1204531200"; 
   d="scan'208";a="348226080"
Subject: Re: [PATCH]  drivers/net/wireless/iwlwifi/iwl-3945.c
From: Zhu Yi <yi.zhu@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Darren Jenkins <darrenrjenkins@gmail.com>,
       kernel Janitors <kernel-janitors@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, ipw2100-admin@linux.intel.com,
       reinette.chatre@intel.com
In-Reply-To: <20080702192457.GB31288@tuxdriver.com>
References: <1214962647.18261.15.camel@localhost.localdomain>
	 <20080702192457.GB31288@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Organization: Intel Corp.
Date: Thu, 03 Jul 2008 09:51:52 +0800
Message-Id: <1215049912.14590.525.camel@debian.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-02 at 15:24 -0400, John W. Linville wrote:
> What about the format line in the IWL_DEBUG_RX that uses rate?
> 
> Also, please use an email subject that is more descriptive than just
> the filename.  You should probably drop the "G'day..." line as well.

Side with John.

> On Wed, Jul 02, 2008 at 11:37:27AM +1000, Darren Jenkins" wrote:
> > G'day people
> > 
> > Coverity CID: 2265 NEGATIVE_RETURNS
> > 
> > "rate" is of an unsigned type, and the code requires a signed type.
> > The following patch makes it so.
> > 
> > Only compile tested.
> > 
> > ﻿Signed-off-by: Darren Jenkins <darrenrjenkins@gmailcom>
> > 
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
> > index 62a3d8f..31d38cd 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-3945.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
> > @@ -449,7 +449,7 @@ static void iwl3945_dbg_report_frame(struct iwl3945_priv *priv,
> >  
> >  	if (print_summary) {
> >  		char *title;
> > -		u32 rate;
> > +		int rate;
> >  
> >  		if (hundred)
> >  			title = "100Frames";

The rate variable here takes two roles: one for calculate the index
(singed) and the other for the actual rate (unsigned). I think if you do
want to fix this, create another local variable int idx to hold the
index result.

Thanks,
-yi

