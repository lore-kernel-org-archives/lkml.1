Return-Path: <linux-kernel-owner+w=401wt.eu-S934441AbZJIV3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934441AbZJIV3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 17:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933380AbZJIV3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 17:29:22 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:24931 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933174AbZJIV3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 17:29:22 -0400
Date: Fri, 9 Oct 2009 14:27:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Greg KH <gregkh@suse.de>
Cc: Bruce Beare <bbeare1@gmail.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Cleanups for: line length, printk KERN_ argument, stack
 frame size > 2048 (added a kmalloc/kfree), style/formatting errors,
 incorrect include files
Message-Id: <20091009142742.b12b80b1.randy.dunlap@oracle.com>
In-Reply-To: <20091009211610.GA5005@suse.de>
References: <1255122698-12390-1-git-send-email-bbeare1@gmail.com>
	<20091009211610.GA5005@suse.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4ACFAB05.00F1:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Oct 2009 14:16:10 -0700 Greg KH wrote:

> 
> Try changing one thing at a time per patch please.
> 
> There's some bugs in here:
> 
> > -		struct config_t dig_in_config[32];
> > -		struct config_t dig_out_config[32];
> > -		struct config_t chan_in_config[32];
> > -		struct config_t chan_out_config[32];
> >  		int i;
> > +		config_data = kmalloc(sizeof(struct config_data_t), GFP_KERNEL);
> 
> Shouldn't that be:
> 		config_data = kmalloc(sizeof(struct config_data_t)*32, GFP_KERNEL);

The new struct already includes the [32]s.


> Otherwise you overflow your buffer here:
> >  
> >  		for (i = 0; i < 32; i++) {
> > -			dig_in_config[i].kind = 0;
> > -			dig_in_config[i].bits = 0;
> > -			dig_in_config[i].min = 0;
> > -			dig_in_config[i].max = 0;
> > -			dig_out_config[i].kind = 0;
> > -			dig_out_config[i].bits = 0;
> > -			dig_out_config[i].min = 0;
> > -			dig_out_config[i].max = 0;
> > -			chan_in_config[i].kind = 0;
> > -			chan_in_config[i].bits = 0;
> > -			chan_in_config[i].min = 0;
> > -			chan_in_config[i].max = 0;
> > -			chan_out_config[i].kind = 0;
> > -			chan_out_config[i].bits = 0;
> > -			chan_out_config[i].min = 0;
> > -			chan_out_config[i].max = 0;
> > +			config_data->dig_in_config[i].kind = 0;
> > +			config_data->dig_in_config[i].bits = 0;
> > +			config_data->dig_in_config[i].min = 0;
> > +			config_data->dig_in_config[i].max = 0;
> > +			config_data->dig_out_config[i].kind = 0;
> > +			config_data->dig_out_config[i].bits = 0;
> > +			config_data->dig_out_config[i].min = 0;
> > +			config_data->dig_out_config[i].max = 0;
> > +			config_data->chan_in_config[i].kind = 0;
> > +			config_data->chan_in_config[i].bits = 0;
> > +			config_data->chan_in_config[i].min = 0;
> > +			config_data->chan_in_config[i].max = 0;
> > +			config_data->chan_out_config[i].kind = 0;
> > +			config_data->chan_out_config[i].bits = 0;
> > +			config_data->chan_out_config[i].min = 0;
> > +			config_data->chan_out_config[i].max = 0;
> >  		}
> 
> Or am I mistaken?

yep.

---
~Randy
