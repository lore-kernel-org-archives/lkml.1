Return-Path: <linux-kernel-owner+w=401wt.eu-S1030595AbXBAPSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030595AbXBAPSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 10:18:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030588AbXBAPSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 10:18:06 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:7974 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161177AbXBAPSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 10:18:05 -0500
Subject: Re: crash on CONFIG_CFAG12864B=y in 2.6.20-rc3-mm1
From: Daniel Walker <dwalker@mvista.com>
To: Miguel Ojeda <maxextreme@gmail.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <653402b90702010716i7c0ddf71xe6fa7866323f52f4@mail.gmail.com>
References: <1168188931.26086.255.camel@imap.mvista.com>
	 <653402b90702010549v17e72765uc718c1ae79419003@mail.gmail.com>
	 <653402b90702010716i7c0ddf71xe6fa7866323f52f4@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 01 Feb 2007 07:16:31 -0800
Message-Id: <1170342991.9781.189.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-01 at 16:16 +0100, Miguel Ojeda wrote:
> The problem is easy:
> 
> ks0108_init() prints the error message and exit with -EINVAL, so the
> module isn't loaded properly.
> 
> However, cfag12864b_init() is called, although ks0108 failed. It
> returns 0 and after a while cfag12864b calls ks0108_writecontrol()
> which dereferences the uninitialized pointer ks0108_parport:
> 
> 	parport_write_control(ks0108_parport, byte ^ (bit(0) | bit(1) | bit(3)));
> 
> Why is cfag12864b_init() called if ks0108 module didn't load properly?
> Is that normal? If so, how a module should alarm other modules about
> it failed loading?

I don't know if this matters, but I had this driver built-in , and not a
module ..

Daniel

