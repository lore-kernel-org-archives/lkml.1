Return-Path: <linux-kernel-owner+w=401wt.eu-S1762091AbZEHUZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762091AbZEHUZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 16:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756243AbZEHUZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 16:25:16 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:13242 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140AbZEHUZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 16:25:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=IrsaFonxo/0bNl12xCl3QKQcKZ6Lu/fyXgrqGq8O7GRWkK1TQgcDfYnHGdKA0IQ7s6
         LZOk6vibRPia33uVjlNJv7yn6gLnrMENV1dKIDDbi1vstldbeHQ3twbHt7euHXawj/NS
         prZGQ+cYVzNDMMOMuLugXAwtAltCYOrn8aCsA=
Message-ID: <4A04951F.8060703@gmail.com>
Date: Fri, 08 May 2009 22:25:03 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-8.7 Thunderbird/3.0b2
MIME-Version: 1.0
To: Karl Relton <karllinuxtest.relton@ntlworld.com>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/wlan-ng: Change KERN_DEBUG or pr_debug to match
 orig driver
References: <1241812457.6459.2.camel@localhost>
In-Reply-To: <1241812457.6459.2.camel@localhost>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2009 09:54 PM, Karl Relton wrote:
> Change uses of KERN_DEBUG over to pr_debug to match original driver
> where messages are only needed during driver development.

Hmm, but many of them don't fit this rule. Some of them should be
honored a higher level, some of them simply should be left as such,
because we want to see the information.

> --- c/drivers/staging/wlan-ng/prism2mgmt.c	2009-04-30 05:48:16.000000000 +0100
> +++ d/drivers/staging/wlan-ng/prism2mgmt.c	2009-05-08 19:11:11.000000000 +0100
> @@ -1096,7 +1096,7 @@ int prism2mgmt_wlansniff(wlandevice_t *w
>  		/* Disable monitor mode */
>  		result = hfa384x_cmd_monitor(hw, HFA384x_MONITOR_DISABLE);
>  		if (result) {
> -			printk(KERN_DEBUG
> +			pr_debug(
>  			       "failed to disable monitor mode, result=%d\n",

rather an ERROR or WARNING?

> --- c/drivers/staging/wlan-ng/prism2sta.c	2009-04-30 05:48:16.000000000 +0100
> +++ d/drivers/staging/wlan-ng/prism2sta.c	2009-05-08 19:15:08.000000000 +0100
> @@ -1188,7 +1188,7 @@ static void prism2sta_inf_chinforesults(
>  			chinforesult->active =
>  			    le16_to_cpu(inf->info.chinforesult.result[n].
>  					    active);
> -			printk(KERN_DEBUG
> +			pr_debug(
>  			       "chinfo: channel %d, %s level (avg/peak)=%d/%d dB, pcf %d\n",

yeah, useless info for an user (the change is OK), but:

> @@ -1276,7 +1276,7 @@ void prism2sta_processing_defer(struct w
>  							wlandev->bssid,
>  							WLAN_BSSID_LEN);
>  			if (result) {
> -				printk(KERN_DEBUG
> +				pr_debug(
>  				       "getconfig(0x%02x) failed, result = %d\n",
>  				       HFA384x_RID_CURRENTBSSID, result);

we want likely to know this one.

etc.
