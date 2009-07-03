Return-Path: <linux-kernel-owner+w=401wt.eu-S1759368AbZGCV2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368AbZGCV2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 17:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756856AbZGCV2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 17:28:06 -0400
Received: from n63.bullet.mail.sp1.yahoo.com ([98.136.44.33]:22274 "HELO
	n63.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753108AbZGCV2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 17:28:06 -0400
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Jul 2009 17:28:06 EDT
X-Yahoo-Newman-Id: 133393.96091.bm@omp424.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Zskqx9O5yqxSrgCYaV6jKLWA2BqKmMICujCYGJTDQP7GXYqVKiIHoii17KF1G7V0LcpoAoP+J8/LH6qr9YIhT5Z4jd3vn3Jcmp9qJksx/Nv5jxKZ1icwUcEho2w+WAWeu8fKOjcBIn7ky+jzQf+N8KZYH6xgFnx61LKZaw5gLpg=  ;
X-YMail-OSG: r1Dy1EIVM1lJBVHx9JLl4ndMH94gu_X5t3wFhJ.HXvMz7IxSwOS4sxqFmjqQD1lnltZ0_0TgHlXY6CVY7TLQPEBoU5NHLQZs6kPGl1mzL7gyz48f0NPI.dnK4CQ23CTsuAB8LHd2ITlziP_EeA8Nb1qjJRQtKtFOqjQNzg5Ph7BhZBXp27H131TfcOegOxMiCpfuCFlDuNRiO9bL60oDNO6Kdn9c_RCf8IzxnHfiyDYsO.nX55b10L94XJZ8Z6gXdfcQv0V2LvmXU2lP9_kUNVQ5Aql.zqOzfzd92wTI4jXUKKpJh5hLMuFCBX2OvGJLdN6qMzdWxDCfcwrjwTdLGuCObirpE7cqGYnlZA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH -next] gadget audio: select SND_PCM
Date: Fri, 3 Jul 2009 14:22:01 -0700
User-Agent: KMail/1.9.10
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       lud <linux-usb@vger.kernel.org>
References: <20090703162443.16495147.sfr@canb.auug.org.au> <20090703132657.3289cdcf.randy.dunlap@oracle.com>
In-Reply-To: <20090703132657.3289cdcf.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907031422.01426.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 July 2009, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix USB gadget audio: select SND_PCM, like many other sound
> drivers do, to fix build errors:
> 
> drivers/built-in.o: In function `f_audio_playback_work':
> audio.c:(.text+0x15a3e7): undefined reference to `snd_pcm_kernel_ioctl'
> audio.c:(.text+0x15a471): undefined reference to `snd_pcm_lib_write'
> drivers/built-in.o: In function `_snd_pcm_hw_param_set':
> audio.c:(.text+0x15aca7): undefined reference to `snd_interval_refine'
> drivers/built-in.o: In function `gaudio_setup':
> (.init.text+0x12adf): undefined reference to `_snd_pcm_hw_params_any'
> drivers/built-in.o: In function `gaudio_setup':
> (.init.text+0x12b43): undefined reference to `snd_pcm_kernel_ioctl'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>


> ---
>  drivers/usb/gadget/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20090703.orig/drivers/usb/gadget/Kconfig
> +++ linux-next-20090703/drivers/usb/gadget/Kconfig
> @@ -604,6 +604,7 @@ config USB_ZERO_HNPTEST
>  config USB_AUDIO
>  	tristate "Audio Gadget (EXPERIMENTAL)"
>  	depends on SND
> +	select SND_PCM
>  	help
>  	  Gadget Audio is compatible with USB Audio Class specification 1.0.
>  	  It will include at least one AudioControl interface, zero or more
> 
> 
> 
> 
> ---
> ~Randy
> LPC 2009, Sept. 23-25, Portland, Oregon
> http://linuxplumbersconf.org/2009/
> 
> 



