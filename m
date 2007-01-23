Return-Path: <linux-kernel-owner+w=401wt.eu-S1751419AbXAXNRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751419AbXAXNRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 08:17:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbXAXNRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 08:17:14 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4674 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751419AbXAXNRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 08:17:13 -0500
Date: Tue, 23 Jan 2007 14:36:14 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] seq_file conversion: APM on mips
Message-ID: <20070123143614.GA6596@ucw.cz>
References: <20070115211413.GB5010@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070115211413.GB5010@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> @@ -456,14 +456,26 @@ static int apm_get_info(char *buf, char 
>  	case 1: 	units = "sec";	break;
>  	}
>  
> -	ret = sprintf(buf, "%s 1.2 0x%02x 0x%02x 0x%02x 0x%02x %d%% %d %s\n",
> +	seq_printf(m, "%s 1.2 0x%02x 0x%02x 0x%02x 0x%02x %d%% %d %s\n",
>  		     driver_version, APM_32_BIT_SUPPORT,
>  		     info.ac_line_status, info.battery_status,
>  		     info.battery_flag, info.battery_life,
>  		     info.time, units);
> +	return 0;
> +}
>  
> - 	return ret;
> +static int proc_apm_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, proc_apm_show, NULL);
>  }
> +
> +static const struct file_operations proc_apm_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= proc_apm_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= single_release,
> +};
>  #endif
>  
>  static int kapmd(void *arg)

Perhaps now is good time to make the code shared?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
