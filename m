Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab0BIAWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 19:22:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751049Ab0BIAWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 19:22:00 -0500
Date: Mon, 8 Feb 2010 16:21:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-acpi@vger.kernel.org,
       Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
       ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thinkpad-acpi: setup hotkey polling after changing
 hotkey_driver_mask
Message-Id: <20100208162153.b317e434.akpm@linux-foundation.org>
In-Reply-To: <20100209000810.GC1420@holoscopio.com>
References: <1265567528-1180-1-git-send-email-cascardo@holoscopio.com>
	<20100208155059.eed393a6.akpm@linux-foundation.org>
	<20100209000810.GC1420@holoscopio.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Feb 2010 22:08:10 -0200
Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com> wrote:

>
> ...
>
> > --- a/drivers/platform/x86/thinkpad_acpi.c~thinkpad-acpi-setup-hotkey-polling-after-changing-hotkey_driver_mask-fix
> > +++ a/drivers/platform/x86/thinkpad_acpi.c
> > @@ -2597,6 +2597,10 @@ static void hotkey_poll_set_freq(unsigne
> >  
> >  #else /* CONFIG_THINKPAD_ACPI_HOTKEY_POLL */
> >  
> > +static void hotkey_poll_setup(bool __unused)
> > +{
> > +}
> > +
> >  static void hotkey_poll_setup_safe(bool __unused)
> >  {
> >  }
> > @@ -2694,9 +2698,7 @@ static ssize_t hotkey_mask_store(struct 
> >  
> >  	res = hotkey_user_mask_set(t);
> >  
> > -#ifdef CONFIG_THINKPAD_ACPI_HOTKEY_POLL
> >  	hotkey_poll_setup(true);
> > -#endif
> >  
> >  	mutex_unlock(&hotkey_mutex);
> >  
> > @@ -6273,9 +6275,7 @@ static int __init brightness_init(struct
> >  				| TP_ACPI_HKEY_BRGHTUP_MASK
> >  				| TP_ACPI_HKEY_BRGHTDWN_MASK);;
> >  
> > -#ifdef CONFIG_THINKPAD_ACPI_HOTKEY_POLL
> > -	hotkey_poll_setup(true);
> > -#endif
> > +	hotkey_poll_setup_safe(true);
> >  
> >  	return 0;
> >  }
> > _
> > 
> 
> How about the added call to volume_init?
> 

I don't know what you mean.

