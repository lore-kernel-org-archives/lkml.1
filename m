Return-Path: <linux-kernel-owner+w=401wt.eu-S1752754AbZHITOC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbZHITOC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 15:14:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbZHITOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 15:14:00 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:44588 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbZHITOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 15:14:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=swutx8eWcy6l5eraxN3Etk24iQ2mnOALJsKiydgBKBPZpa9H2yUHVqEyAa5FnSkwpE
         R/Zdixjli6eMBWseVXiqxtBvmknTzOhFIjSz1IJ3RkWF6uHQNByekiouEMvIwKlvFoZE
         +j+SffXqm1omZtZtKcO08rWHApO/gGTDf2KEY=
Date: Sun, 9 Aug 2009 23:13:59 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Roel Kluin <roel.kluin@gmail.com>, Daniel Mack <daniel@caiaq.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Libertas: Association request to the driver failed
Message-ID: <20090809191359.GG4805@lenovo>
References: <20090807191156.GS19257@buzzloop.caiaq.de> <20090809102417.GH13639@buzzloop.caiaq.de> <4A7EAED8.9090900@gmail.com> <200908091310.56919.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908091310.56919.mb@bu3sch.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Michael Buesch - Sun, Aug 09, 2009 at 01:10:56PM +0200]
| On Sunday 09 August 2009 13:11:20 Roel Kluin wrote:
| > @@ -43,21 +44,21 @@ static int get_common_rates(struct lbs_private *priv,
| >  	u16 *rates_size)
| >  {
| >  	u8 *card_rates = lbs_bg_rates;
| > -	size_t num_card_rates = sizeof(lbs_bg_rates);
| >  	int ret = 0, i, j;
| > -	u8 tmp[30];
| > +	u8 tmp[*rates_size * ARRAY_SIZE(lbs_bg_rates)];
| 
| Is it a good idea to use dynamic stack arrays in the kernel?
| What about kmalloc for dynamic allocations?
| 
| -- 
| Greetings, Michael.

I saw one pattern in trace code (not sure if it's
still there) but personally don't like dynamic
stack arrays (though at moment the max value
being passed into routine is known maybe just
use MAX_RATES instead of (*rates_size)?). Hmm?

	-- Cyrill
