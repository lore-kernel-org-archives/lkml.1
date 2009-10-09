Return-Path: <linux-kernel-owner+w=401wt.eu-S1761469AbZJIVdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761469AbZJIVdj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 17:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760232AbZJIVdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 17:33:38 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:34592 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbZJIVdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 17:33:38 -0400
Date: Fri, 9 Oct 2009 14:31:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Bruce B <bbeare1@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Bill Pemberton <wfp5p@virginia.edu>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Cleanups for: line length, printk KERN_ argument, stack
 frame size > 2048 (added a kmalloc/kfree), style/formatting errors,
 incorrect include files
Message-Id: <20091009143124.72ce7f20.randy.dunlap@oracle.com>
In-Reply-To: <D0384E25-2A85-442D-95C5-115A12514110@gmail.com>
References: <1255122698-12390-1-git-send-email-bbeare1@gmail.com>
	<20091009142303.c807a531.randy.dunlap@oracle.com>
	<D0384E25-2A85-442D-95C5-115A12514110@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4ACFAC06.0036:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Oct 2009 14:29:19 -0700 Bruce B wrote:

> 
> On Oct 9, 2009, at 2:23 PM, Randy Dunlap wrote:
> 
> > On Fri,  9 Oct 2009 14:11:38 -0700 Bruce Beare wrote:
> >
> >> ---
> >> drivers/staging/comedi/drivers/serial2002.c |  342 ++++++++++ 
> >> +---------------
> >> 1 files changed, 145 insertions(+), 197 deletions(-)
> >>
> >> diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/ 
> >> staging/comedi/drivers/serial2002.c
> >> index a219679..0232186 100644
> >> --- a/drivers/staging/comedi/drivers/serial2002.c
> >> +++ b/drivers/staging/comedi/drivers/serial2002.c
> >> @@ -413,34 +408,37 @@ static void serial_2002_open(struct  
> >> comedi_device *dev)
> >> 			int min;
> >> 			int max;
> >> 		};
> >> +		struct config_data_t {
> >> +			struct config_t dig_in_config[32];
> >> +			struct config_t dig_out_config[32];
> >> +			struct config_t chan_in_config[32];
> >> +			struct config_t chan_out_config[32];
> >> +		} *config_data = NULL;
> >>
> >> -		struct config_t dig_in_config[32];
> >> -		struct config_t dig_out_config[32];
> >> -		struct config_t chan_in_config[32];
> >> -		struct config_t chan_out_config[32];
> >> 		int i;
> >> +		config_data = kmalloc(sizeof(struct config_data_t), GFP_KERNEL);
> >
> > what happens when the kmalloc() fails??
> 
> Nothing good. The driver ignores the return code in numerous places  
> and the open routine in this case is defined to be a void return.
> I considered it to be a general cleanup subject for this driver at a  
> later date.

I would say sooner than later.

> >>
> >> 		for (i = 0; i < 32; i++) {
> >> -			dig_in_config[i].kind = 0;
> >> -			dig_in_config[i].bits = 0;
> >> -			dig_in_config[i].min = 0;
> >> -			dig_in_config[i].max = 0;
> >> -			dig_out_config[i].kind = 0;
> >> -			dig_out_config[i].bits = 0;
> >> -			dig_out_config[i].min = 0;
> >> -			dig_out_config[i].max = 0;
> >> -			chan_in_config[i].kind = 0;
> >> -			chan_in_config[i].bits = 0;
> >> -			chan_in_config[i].min = 0;
> >> -			chan_in_config[i].max = 0;
> >> -			chan_out_config[i].kind = 0;
> >> -			chan_out_config[i].bits = 0;
> >> -			chan_out_config[i].min = 0;
> >> -			chan_out_config[i].max = 0;
> >> +			config_data->dig_in_config[i].kind = 0;
> >> +			config_data->dig_in_config[i].bits = 0;
> >> +			config_data->dig_in_config[i].min = 0;
> >> +			config_data->dig_in_config[i].max = 0;
> >> +			config_data->dig_out_config[i].kind = 0;
> >> +			config_data->dig_out_config[i].bits = 0;
> >> +			config_data->dig_out_config[i].min = 0;
> >> +			config_data->dig_out_config[i].max = 0;
> >> +			config_data->chan_in_config[i].kind = 0;
> >> +			config_data->chan_in_config[i].bits = 0;
> >> +			config_data->chan_in_config[i].min = 0;
> >> +			config_data->chan_in_config[i].max = 0;
> >> +			config_data->chan_out_config[i].kind = 0;
> >> +			config_data->chan_out_config[i].bits = 0;
> >> +			config_data->chan_out_config[i].min = 0;
> >> +			config_data->chan_out_config[i].max = 0;
> >> 		}


---
~Randy
