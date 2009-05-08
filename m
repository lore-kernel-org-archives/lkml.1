Return-Path: <linux-kernel-owner+w=401wt.eu-S1764076AbZEHUy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764076AbZEHUy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 16:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755502AbZEHUyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 16:54:50 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:15606 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754823AbZEHUyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 16:54:50 -0400
X-Greylist: delayed 3624 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 May 2009 16:54:49 EDT
Subject: Re: [PATCH] staging/wlan-ng: Change KERN_DEBUG or pr_debug to
 match orig driver
From: Karl Relton <karllinuxtest.relton@ntlworld.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4A04951F.8060703@gmail.com>
References: <1241812457.6459.2.camel@localhost> <4A04951F.8060703@gmail.com>
Content-Type: text/plain
Date: Fri, 08 May 2009 21:54:46 +0100
Message-Id: <1241816086.6459.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.0 c=1 a=gpGDuW15Bh8A:10 a=34Ld2yrW4hAA:10 a=6UWwUf1ebYGkXz9Qp-4A:9 a=dzf08rUCoDBTkqHJkaYA:7 a=2ryqrcbORycpnLgPeKp4j9A0z74A:4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-08 at 22:25 +0200, Jiri Slaby wrote:
> On 05/08/2009 09:54 PM, Karl Relton wrote:
> > Change uses of KERN_DEBUG over to pr_debug to match original driver
> > where messages are only needed during driver development.
> 
> Hmm, but many of them don't fit this rule. Some of them should be
> honored a higher level, some of them simply should be left as such,
> because we want to see the information.
> 

I see your point, but the motivation of this patch was to be consistent
with the original out-of-tree driver. For all these messages that used
its own macro WLAN_LOG_DEBUG which depended on a compile-time flag. For
normal use, the flag would be unset which meant you would get none of
the messages.

Now I agree that you could question the logic of some of the messages
being 'debug only' - but there are probably lots of other messages in
this driver that also have a questionable level. Previously someone else
had already converted some of messages to pr_debug - this patch merely
cleaned up to make them consistent (with the original driver).

Karl

> > --- c/drivers/staging/wlan-ng/prism2mgmt.c	2009-04-30 05:48:16.000000000 +0100
> > +++ d/drivers/staging/wlan-ng/prism2mgmt.c	2009-05-08 19:11:11.000000000 +0100
> > @@ -1096,7 +1096,7 @@ int prism2mgmt_wlansniff(wlandevice_t *w
> >  		/* Disable monitor mode */
> >  		result = hfa384x_cmd_monitor(hw, HFA384x_MONITOR_DISABLE);
> >  		if (result) {
> > -			printk(KERN_DEBUG
> > +			pr_debug(
> >  			       "failed to disable monitor mode, result=%d\n",
> 
> rather an ERROR or WARNING?
> 
> > --- c/drivers/staging/wlan-ng/prism2sta.c	2009-04-30 05:48:16.000000000 +0100
> > +++ d/drivers/staging/wlan-ng/prism2sta.c	2009-05-08 19:15:08.000000000 +0100
> > @@ -1188,7 +1188,7 @@ static void prism2sta_inf_chinforesults(
> >  			chinforesult->active =
> >  			    le16_to_cpu(inf->info.chinforesult.result[n].
> >  					    active);
> > -			printk(KERN_DEBUG
> > +			pr_debug(
> >  			       "chinfo: channel %d, %s level (avg/peak)=%d/%d dB, pcf %d\n",
> 
> yeah, useless info for an user (the change is OK), but:
> 
> > @@ -1276,7 +1276,7 @@ void prism2sta_processing_defer(struct w
> >  							wlandev->bssid,
> >  							WLAN_BSSID_LEN);
> >  			if (result) {
> > -				printk(KERN_DEBUG
> > +				pr_debug(
> >  				       "getconfig(0x%02x) failed, result = %d\n",
> >  				       HFA384x_RID_CURRENTBSSID, result);
> 
> we want likely to know this one.
> 
> etc.
> 

