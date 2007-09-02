Return-Path: <linux-kernel-owner+w=401wt.eu-S932948AbXIBWMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948AbXIBWMb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 18:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbXIBWMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 18:12:24 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:48563 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbXIBWMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 18:12:23 -0400
Message-ID: <46DB33D0.40204@gmail.com>
Date: Mon, 03 Sep 2007 00:06:08 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Satyam Sharma <satyam@infradead.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>,
       alsa-devel@alsa-project.org
Subject: Re: [PATCH -mm] sb16: Shut up uninitialized var build warning
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i n> <alpine.LFD.0.999.0709030143550.29617@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0709030143550.29617@enigma.security.iitk.ac.in>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2007 10:15 PM, Satyam Sharma wrote:

> sound/isa/sb16/sb16.c: In function ‘snd_sb16_isa_probe’:

Blah. Your message has:

	Content-Type: TEXT/PLAIN; charset=iso-2022-jp

This apparently is caused by a combination of GCC using groovy UTF tickmarks 
in its error messages when in a UTF locale and alpine believing it to be a 
great idea to automatically try for the "simplest" character set it can 
encode the content in. No idea why that means that iso-2022-jp is picked, 
but it is.

While I could actually read the message this time you should see what 
iso-2022-jp does to my font. It's scary. Best solution as far as I'm 
concerned is slap a few GCC developers (not that it wil help, but it'll 
certainly feel good) and then teach alpine to go for UTF-8 directly if 
US-ASCII won't do.

As to the content of this patch -- I'd almost say it's better to live with 
the warning than with that unitialized_var() thing. That ARRAY_SIZE is very 
much a compile time constant, so exactly how dumb must GCC get before we get 
to say to here and no further?

> --- linux-2.6.23-rc4-mm1/sound/isa/sb/sb16.c~fix	2007-09-02 21:41:51.000000000 +0530
> +++ linux-2.6.23-rc4-mm1/sound/isa/sb/sb16.c	2007-09-02 21:42:56.000000000 +0530
> @@ -556,7 +556,6 @@ static int __devinit snd_sb16_isa_match(
>  
>  static int __devinit snd_sb16_isa_probe(struct device *pdev, unsigned int dev)
>  {
> -	int err;
>  	static int possible_irqs[] = {5, 9, 10, 7, -1};
>  	static int possible_dmas8[] = {1, 3, 0, -1};
>  	static int possible_dmas16[] = {5, 6, 7, -1};
> @@ -585,6 +584,8 @@ static int __devinit snd_sb16_isa_probe(
>  	else {
>  		static int possible_ports[] = {0x220, 0x240, 0x260, 0x280};
>  		int i;
> +		int uninitialized_var(err);
> +
>  		for (i = 0; i < ARRAY_SIZE(possible_ports); i++) {
>  			port[dev] = possible_ports[i];
>  			err = snd_sb16_isa_probe1(dev, pdev);

Rene.

