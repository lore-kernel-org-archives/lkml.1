Return-Path: <linux-kernel-owner+w=401wt.eu-S1762263AbZLKCsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762263AbZLKCsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 21:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762225AbZLKCsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 21:48:10 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:61283 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762135AbZLKCsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 21:48:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=fjAH4UUfEMj8+71Ihy8r7lE1rNlBcOH3pzBi4V3bQbRSpTSaY82xkD8p9RRxxnJVNS
         6xl9Zb/hnLdseJpIWoOOY1eYOvHj/v+YJ6HDLG/PEyFPQ9E4IIc0PwduUMObiWMyTn7A
         WYXr+blS0nk7aGG4z1qaoaHDeKu9jAWIzxF1E=
Subject: Re: [PATCH v9 8/8] Loongson: YeeLoong: add input/hotkey driver
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Ralf Baechle <ralf@linux-mips.org>
Cc: akpm@linux-foundation.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Rafael J . Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       linux-laptop@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <e6d590fa37e6003dd482918fdef02c1fc127d6c8.1260281599.git.wuzhangjin@gmail.com>
References: <cover.1260254344.git.wuzhangjin@gmail.com>
	 <39d232e3f8359e9c11bad7536f0162444401ec94.1260281599.git.wuzhangjin@gmail.com>
	 <7676d8397e593dbec0d40e24429b7ccbcecfa588.1260281599.git.wuzhangjin@gmail.com>
	 <4d821efaecc3dee0b9124119507a694e81572437.1260281599.git.wuzhangjin@gmail.com>
	 <5c426a5091bee3e4483fc0b93f26359e2840428b.1260281599.git.wuzhangjin@gmail.com>
	 <5e9acb4cd757075f617daa45cbd6f5fad94678ac.1260281599.git.wuzhangjin@gmail.com>
	 <234c5ecd475b05e3eb17ead3ae107cfe3426e0e0.1260281599.git.wuzhangjin@gmail.com>
	 <6af33d6c42ba4de9eea27316c64f81b96e01c948.1260281599.git.wuzhangjin@gmail.com>
	 <e6d590fa37e6003dd482918fdef02c1fc127d6c8.1260281599.git.wuzhangjin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: DSLab, Lanzhou University, China
Date: Fri, 11 Dec 2009 10:47:40 +0800
Message-ID: <1260499660.3193.17.camel@falcon.domain.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-08 at 22:15 +0800, Wu Zhangjin wrote:
> From: Wu Zhangjin <wuzhangjin@gmail.com>
> 
> This patch adds Hotkey Driver, which will do related actions for The
> hotkey event(/sys/class/input) and report the corresponding input keys
> to the user-space applications.
> 
> [NOTE:
> 
> This patch is based on the sparse keymap library in:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input next
> 
> of Dmitry Torokhov. that sparse keymap support is also queued for
> 2.6.33. Before the above branch is pulled by linus, this patch is not
> appliable.]
> 
[...]
> +
> +/* yeeloong_wifi_handler may be implemented in the wifi driver */
> +sci_handler yeeloong_wifi_handler;
> +EXPORT_SYMBOL(yeeloong_wifi_handler);
> +

Because we have reported the KEY_WLAN to user-space and If we provide
the standard rfkill interfaces too, there is no need to handle the Fn+F5
event in kernel space, will remove the above three lines the following
related source code.

> +static void do_event_action(int event)
> +{
> +	sci_handler handler;
> +	int reg, status;
> +	struct key_entry *ke;
> +
> +	reg = 0;
> +	handler = NULL;
> +
> +	switch (event) {
[...]
> +	case EVENT_WLAN:
> +		/* We use 2 to indicate it as a switch */
> +		status = 2;
> +		handler = yeeloong_wifi_handler;
> +		break;

Will remove it and send the this patch as v10 later.

Best Regards,
	Wu Zhangjin

