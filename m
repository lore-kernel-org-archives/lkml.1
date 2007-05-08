Return-Path: <linux-kernel-owner+w=401wt.eu-S1032276AbXEHVQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032276AbXEHVQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:16:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032185AbXEHVQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:16:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36598 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032268AbXEHVQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:16:04 -0400
Subject: Re: [PATCH 1/2] V4L: videodev, allow VIDIOCGMBUF
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <32177258712660011096@wsc.cz>
References: <32177258712660011096@wsc.cz>
Content-Type: text/plain
Date: Tue, 08 May 2007 18:15:38 -0300
Message-Id: <1178658938.18383.375.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

>	if (_IOC_TYPE(cmd)=='v')
> -		return v4l_compat_translate_ioctl(inode,file,cmd,arg,
> +#ifdef CONFIG_VIDEO_V4L1_COMPAT
> +		if (cmd != VIDIOCGMBUF) /* <-- handled below vvv */
> +#endif
> +			return v4l_compat_translate_ioctl(inode,file,cmd,arg,
>  						__video_do_ioctl);
> 
I've committed two patches on my -git tree that will fix the issue
you're pointing. 

In fact, all the above code should be handled only if V4L1_COMPAT is
enabled. The fixes are at the following patches:

http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=11fe647ca79d1e6381f954a7fe790a1157c803dc

http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=853fa89dd933b90f820d4bd46a71542bfb3d5967

Cheers,
Mauro

