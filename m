Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbYKURFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbYKURFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbYKURF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:05:28 -0500
Received: from an-out-0708.google.com ([209.85.132.251]:29238 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbYKURF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:05:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RA8lSSq/NAeATMUq93wN2hlJuJJgf8UGh8GatcYoPmmik3gUfGVIP+W9C/pNCz6oUW
         +YPAGSYheST8QB0DcYdHUEwu8a2MXczAP+MAybwMrWZ2vsibAfx8L/FhBBWTe+LdQJHg
         oR4en8e5ULuTSlIugUbYekZhaMRG4pt9R2ffE=
Date: Fri, 21 Nov 2008 12:05:20 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: stefan@datenfreihafen.org
Cc: eric.y.miao@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Daniel Ribeiro <drwyrm@gmail.com>
Subject: Re: [patch 08/14] input: PCAP2 based touchscreen driver
Message-ID: <20081121170518.GA4416@USFSHXP-002051>
References: <20081121160403.073751031@dodger.lab.datenfreihafen.org> <20081121160521.959037675@dodger.lab.datenfreihafen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121160521.959037675@dodger.lab.datenfreihafen.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 05:04:11PM +0100, stefan@datenfreihafen.org wrote:
> Touchscreen driver based on the PCAP2 multi function device.
> 
> Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>
> 
> +
> +static int __devexit pcap_ts_remove(struct platform_device *pdev)
> +{
> +	ezx_pcap_unregister_event(PCAP_IRQ_TS);
> +
> +	del_timer_sync(&pcap_ts->timer);
> +
> +	input_unregister_device(pcap_ts->input);
> +	kfree(pcap_ts);
> +

Could pcap_ts->work be still running at this point?

> +	return 0;
> +}
> +
> +}
> +#else
> +
> +#define pcap_ts_suspend NULL
> +#define pcap_ts_resume  NULL
> +
> +#endif
> +
> +static struct platform_driver pcap_ts_driver = {
> +	.probe		= pcap_ts_probe,
> +	.remove		= __devexit_p(pcap_ts_remove),
> +	.suspend	= pcap_ts_suspend,
> +	.resume		= pcap_ts_resume,

I think it is preferred that .suspend and .resume assigments are
guarded by #ifdef CONFIG_PM, not creating NULL stubs as this will
(theoretically) allow removing .suspend and .resume pointers from
driver stucture when compiling without PM support.

Also try running through checkpatch.pl - there are a few warnings I'd
like to be fixed as well. Otherwise looks pretty good.

Oh, and you need to add your sign-off please. Thanks!

-- 
Dmitry
