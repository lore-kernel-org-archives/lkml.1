Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762AbYDRNIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbYDRNIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 09:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbYDRNIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 09:08:05 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:4198 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbYDRNIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 09:08:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=EaYiNO9OJKLWzxJOwf0hZOuyLRhtyGjBdJ5dgRcw5Ee2mAVUGlAbB1jaIHxmphVZzkxZTqF7XDL/F7SkJtqBE8yKQ3uEMtAw4AbMq5ZZ8PioZSDtxao7lft+nFa4wZMe8DGg1r8QLCWqdMtfcYSMj450+KOSGa5i0LDt2z182Ys=
Date: Fri, 18 Apr 2008 17:07:19 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: bfields@fieldses.org, neilb@suse.de, ibm-acpi@hmh.eng.br,
       len.brown@intel.com, kkeil@suse.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] ThinkPad ACPI: fix possible NULL pointer
	dereference
Message-ID: <20080418130719.GB7674@cvg>
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
| 

Oh, I see what do you mean - you mean that even if machine is ThinkPad
*but* kstrdup failed with my patch it would lead that the machine will
*not* be recognized as ThinkPad and that is not correct, agreed. But how
to preven from NULL dereference then? I think the current situation
brought by my patch would not lead to really critical problems *but*
it should be reorganized indeed! Thanks a lot, Pavel, for comments ;)

		- Cyrill -
