Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbZDZPbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbZDZPbT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 11:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbZDZPbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 11:31:07 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44804 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbZDZPbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 11:31:06 -0400
Date: Sun, 26 Apr 2009 16:31:01 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org
Subject: Re: [PATCH] Acer Aspire One Fan Control
Message-ID: <20090426153100.GA7481@srcf.ucam.org>
References: <cone.1240623959.159615.9486.1000@mentalhome> <cone.1240648971.372002.7492.1000@mentalhome>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cone.1240648971.372002.7492.1000@mentalhome>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 25, 2009 at 10:42:51AM +0200, Peter Feuerer wrote:

Looks pretty good. Couple of minor questions:

> +	  The driver is started in "user" mode where the Bios takes care about
> +	  controlling the fan, unless a userspace program controls it.
> +	  To let the kernelmodule handle the fan, do:
> +	  echo kernel > /sys/class/thermal/thermal_zone0/mode
> +
> +	  For more information about this driver see
> +	  <http://piie.net/files/acerhdf_README.txt>

Maybe include the readme in Documentation/laptop?

> +/* if you want the module to be started in kernelmode,
> + * uncomment following line */
> +/* #define START_IN_KERNEL_MODE */

Maybe a module parameter?

> +/* set operation mode;
> + * kernel: a kernel thread takes care about managing the
> + *	 fan (see acerhdf_thread)
> + * user: kernel thread is stopped and a userspace tool
> + *	 should take care about managing the fan

This could be clearer. In user mode the fan will be controlled by the 
bios, right?

> +	/* silly hack - let the polling thread disable
> +	 * kernelmode. This ensures, that the polling thread
> +	 * doesn't switch off the fan again */

Is this still needed?

> +static int acerhdf_suspend(struct platform_device *dev,
> +		pm_message_t state)
> +{
> +	if (verbose)
> +		printk(KERN_NOTICE "acerhdf: going suspend\n");
> +	return 0;
> +}
> +
> +/* wake up */
> +static int acerhdf_resume(struct platform_device *device)
> +{
> +	if (verbose)
> +		printk(KERN_NOTICE "acerhdf: resuming\n");
> +	return 0;
> +}

Just remove these.

> +	/* print out bios data */
> +	printk(KERN_NOTICE "acerhdf: version: %s compilation date: %s %s\n",
> +			VERSION, __DATE__, __TIME__);
> +	printk(KERN_NOTICE "acerhdf: biosvendor:%s\n", vendor);
> +	printk(KERN_NOTICE "acerhdf: biosversion:%s\n", version);
> +	printk(KERN_NOTICE "acerhdf: biosrelease:%s\n", release);
> +	printk(KERN_NOTICE "acerhdf: biosproduct:%s\n", product);

Perhaps only do this if verbose mode is enabled? 5 lines of output for 
one driver seems excessive.

> +		printk(KERN_NOTICE
> +			"acerhdf: kernelmode disabled\n");
> +		printk(KERN_NOTICE
> +			"acerhdf: to enable kernelmode:\n");
> +		printk(KERN_NOTICE
> +			"acerhdf: echo -n \"enabled\" > "
> +			"/sys/class/thermal/thermal_zone0/mode\n");
> +		printk(KERN_NOTICE
> +			"acerhdf: for more information read:\n");
> +		printk(KERN_NOTICE
> +			"acerhdf: http://piie.net/files/acerhdf_README.txt\n");

This is the default behaviour, right? So that's another 5 lines by 
default. I don't think it's really necessary :)

I don't have an Aspire One to hand so can't test this, but otherwise it 
looks pretty good.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
