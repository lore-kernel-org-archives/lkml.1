Return-Path: <linux-kernel-owner+w=401wt.eu-S1751449AbXAXNug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbXAXNug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 08:50:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbXAXNug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 08:50:36 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:58486 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbXAXNuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 08:50:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LdDXdkdBVLeY/iazLf8lEXDggagYYyG8O+rple/TXaX22J7WjHSVmli85CHpL9IOjmjOBsmers4L6EMqDT6MEIeb2FdyAHTfgpYoTEYIqekcVI7clNrfLi3/Px/67lj9eNfvS2V9+Gah5tsa5bmPzojOJ7vqhugL2dN6SykuVNE=
Message-ID: <b6fcc0a0701240550t3156782eub36b41a0d6ffe75c@mail.gmail.com>
Date: Wed, 24 Jan 2007 16:50:34 +0300
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: [PATCH] seq_file conversion: APM on mips
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
In-Reply-To: <20070123143614.GA6596@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070115211413.GB5010@martell.zuzino.mipt.ru>
	 <20070123143614.GA6596@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/23/07, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> > @@ -456,14 +456,26 @@ static int apm_get_info(char *buf, char
> >  	case 1: 	units = "sec";	break;
> >  	}
> >
> > -	ret = sprintf(buf, "%s 1.2 0x%02x 0x%02x 0x%02x 0x%02x %d%% %d %s\n",
> > +	seq_printf(m, "%s 1.2 0x%02x 0x%02x 0x%02x 0x%02x %d%% %d %s\n",
> >  		     driver_version, APM_32_BIT_SUPPORT,
> >  		     info.ac_line_status, info.battery_status,
> >  		     info.battery_flag, info.battery_life,
> >  		     info.time, units);
> > +	return 0;
> > +}
> >
> > - 	return ret;
> > +static int proc_apm_open(struct inode *inode, struct file *file)
> > +{
> > +	return single_open(file, proc_apm_show, NULL);
> >  }
> > +
> > +static const struct file_operations proc_apm_fops = {
> > +	.owner		= THIS_MODULE,
> > +	.open		= proc_apm_open,
> > +	.read		= seq_read,
> > +	.llseek		= seq_lseek,
> > +	.release	= single_release,
> > +};
> >  #endif
> >
> >  static int kapmd(void *arg)
>
> Perhaps now is good time to make the code shared?

Well, my intention was to remove last ->get_info users and
remove struct proc_dir_entry::get_info altogether.

I didn't know about APM merging efforts.
