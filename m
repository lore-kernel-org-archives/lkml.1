Return-Path: <linux-kernel-owner+w=401wt.eu-S934559AbZJIV47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934559AbZJIV47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 17:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933225AbZJIV46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 17:56:58 -0400
Received: from fifo99.com ([67.223.236.141]:60857 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934307AbZJIV46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 17:56:58 -0400
Subject: Re: [PATCH] Cleanups for: line length, printk KERN_ argument,
 stack frame size > 2048 (added a kmalloc/kfree), style/formatting errors,
 incorrect include files
From: Daniel Walker <dwalker@fifo99.com>
To: Bruce B <bbeare1@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Bill Pemberton <wfp5p@virginia.edu>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
In-Reply-To: <936929F4-6F9E-4DE2-B3C1-1B2E16D2AEC2@gmail.com>
References: <1255122698-12390-1-git-send-email-bbeare1@gmail.com>
	 <20091009211610.GA5005@suse.de>
	 <936929F4-6F9E-4DE2-B3C1-1B2E16D2AEC2@gmail.com>
Content-Type: text/plain
Date: Fri, 09 Oct 2009 14:55:29 -0700
Message-Id: <1255125329.18167.412.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-09 at 14:31 -0700, Bruce B wrote:
> 
> 
> On Oct 9, 2009, at 2:16 PM, Greg KH wrote:
> 
> >
> > Try changing one thing at a time per patch please.
> >
> > There's some bugs in here:
> >
> >> -		struct config_t dig_in_config[32];
> >> -		struct config_t dig_out_config[32];
> >> -		struct config_t chan_in_config[32];
> >> -		struct config_t chan_out_config[32];
> >> 		int i;
> >> +		config_data = kmalloc(sizeof(struct config_data_t), GFP_KERNEL);
> >
> > Shouldn't that be:
> > 		config_data = kmalloc(sizeof(struct config_data_t)*32, GFP_KERNEL);
> 
> 
> The structure already has the [32]'s copied from the original defn's.
> If you like... I can still break up the commit into two patches. Also,  
> moving the *32 out isn't a bad idea; were I
> to break it up, I would likely do so.

I would break it up .. Especially pulling out run time changes from
cleanups .. Also neither patch has a sign off line, and this patch
actually adds one line over 80 so that at least doesn't go along with
your subject..

If your going to respin this patches your first patch "[PATCH] Cleanup:
indent/format errors, printk calls." added some trailing whitespace too.
So you could do both..

Daniel

