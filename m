Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbYDRMz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbYDRMz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 08:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbYDRMzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 08:55:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:6701 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbYDRMzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 08:55:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=QhgQTDTOc8+7Jm9nT+OgeKl1L5is/mRTdCucmq40r9POXDhz5OBjydTgtKpfcTt9vwg3mamfu0nEPTHwrx9fNFkN4K5yEkiFvACi4quaSncLJ0qttq8v4us7LiJAg/wn5yirhg57fw0SZf8+BZ8Xlv5gtbsXh0+AmHxathtBBsk=
Date: Fri, 18 Apr 2008 16:55:02 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: bfields@fieldses.org, neilb@suse.de, ibm-acpi@hmh.eng.br,
       len.brown@intel.com, kkeil@suse.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] ThinkPad ACPI: fix possible NULL pointer
	dereference
Message-ID: <20080418125502.GA7674@cvg>
References: <20080416174421.442716301@gmail.com>> <48063bc9.2533440a.1932.1fc1@mx.google.com> <20080418124111.GB4966@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080418124111.GB4966@ucw.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Pavel Machek - Fri, Apr 18, 2008 at 02:41:12PM +0200]
| Hi!
| 
| > Fix potential NULL pointer dereference if kstrdup failed
| > 
| > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| > 
| > ---
| > 
| > Index: linux-2.6.git/drivers/misc/thinkpad_acpi.c
| > ===================================================================
| > --- linux-2.6.git.orig/drivers/misc/thinkpad_acpi.c	2008-04-16 20:35:34.000000000 +0400
| > +++ linux-2.6.git/drivers/misc/thinkpad_acpi.c	2008-04-16 20:36:38.000000000 +0400
| > @@ -5826,7 +5826,7 @@ static void __init get_thinkpad_model_da
| >  
| >  	tp->model_str = kstrdup(dmi_get_system_info(DMI_PRODUCT_VERSION),
| >  					GFP_KERNEL);
| > -	if (strnicmp(tp->model_str, "ThinkPad", 8) != 0) {
| > +	if (tp->model_str && strnicmp(tp->model_str, "ThinkPad", 8) != 0) {
| >  		kfree(tp->model_str);
| >  		tp->model_str = NULL;
| >  	}
| 
| are you sure? This seems to assume machine is thinkpad if kstrdup
| fails... which is very wrong.

No, it's *not* wrong, look there we have

	tp->model_str = kstrdup(dmi_get_system_info(DMI_PRODUCT_VERSION),
						GFP_KERNEL);

lets assume we've got NULL here so probe_for_thinkpad() will check for it

	is_thinkpad = (thinkpad_id.model_str != NULL);


Thanks for comment

		- Cyrill -
