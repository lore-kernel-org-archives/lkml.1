Return-Path: <linux-kernel-owner+w=401wt.eu-S1761554AbYD3VJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761554AbYD3VJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755445AbYD3VJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:09:06 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:30753 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbYD3VJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:09:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=xIKR1VPA7fg3FjESDql5w1DFekAadm1vcZwT5x0C6X6LHFjWSNYLs31bIFmCC6miNAZVIKCyoV6wRpKZvm80uU1rnKTBV+kzQjCKMP+kSE89oGLbqxpyoiSmz9nvl8wwZ0jAHalgAE8yKTnA8ovS7QSh1DmRcE8qxvRiJTHpyr8=
Date: Wed, 30 Apr 2008 17:02:50 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] input: JOYSTICK_XPAD build fix
Message-ID: <20080430170125.ZZRA012@mailhub.coreip.homeip.net>
References: <20080430200340.GA13757@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430200340.GA13757@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 10:03:40PM +0200, Ingo Molnar wrote:
> x86.git testing found the following build failure in -git:
> 
>  ERROR: "led_classdev_register" [drivers/input/joystick/xpad.ko] undefined!
>  ERROR: "led_classdev_unregister" [drivers/input/joystick/xpad.ko] undefined!
> 
> which triggers with the following config:
> 
>  http://redhat.com/~mingo/misc/config-Wed_Apr_30_21_43_17_CEST_2008.bad
> 
> the reason is dependency on NEW_LEDS that was not spelled out in the
> Kconfig entry of JOYSTICK_XPAD.
> 

Xpad can be compiled without LED support so this dependancy is
incorrect. JOYSTICK_XPAD_LEDS has proper dependancy on LEDS_CLASS, the
rest is Kconfig breakage.

-- 
Dmitry
