Return-Path: <linux-kernel-owner+w=401wt.eu-S1764207AbXJSA42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764207AbXJSA42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 20:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756665AbXJSA4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 20:56:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:15580 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758560AbXJSA4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 20:56:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rBR0M9WJ1P1m5RJCvE9SsSfCNlS6Dlga8I+/0w2JBxqjYxInxJmrQBKguXSfeB6S2Z4gkrGBUBtdlS4e0/wTiKaE8ljoHnWDSBpaM/YmH7KnpfyYqj15MOeVjwgSM5V6Ayf2AdrwrVxUi93IOgW8OKjJoNS2RmAgw00ndkDIUpY=
Message-ID: <f17812d70710181756n67c92f31p7f37eaed88f33aea@mail.gmail.com>
Date: Fri, 19 Oct 2007 08:56:18 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "Kristoffer Ericson" <kristoffer.ericson@gmail.com>
Subject: Re: PDA Suspend SA1100
Cc: "Russell King" <linux@arm.linux.org.uk>,
       Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-main <linux-kernel@vger.kernel.org>
In-Reply-To: <20071019013736.11dec046.Kristoffer.ericson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071019013736.11dec046.Kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/07, Kristoffer Ericson <kristoffer.ericson@gmail.com> wrote:
> Greetings,
>
> I've been trying to implement proper suspend on my jornada 720 machine. But as far as I can see it never reaches
> the sa11x0_suspend code.
>
> I've linked power button event to produce APM_SUSPEND and I can see that it says "Stopping TASKS ======". It then
> blanks screen but keeps LCD powerd. I know it goes into resume again since removing backlight code in resume function
> effectivly turns off the LCD.
>
> Im assuming that it tries to suspend but fails at some point and tries to return into normal operations?
> Exactly what is needed to get the suspend procedure happy? Does every driver need to have suspend/resume code?

I don't think so. Unless a driver feels it necessary to take some
action, no suspend/resume
will not cause the whole system to fail. However,

1) if any driver suspend code returns error, the whole procedure will stop
2) and instable wake-up source (like glitch on wake-up GPIO pin) or
incorrect setting (like
wake up from RTC but set the interval to be 0) will also cause the
immediate resume

check "sa11x0_suspend" print out won't work since the console has already been
suspended, try DISABLE_CONSOLE_SUSPEND or other ways

- eric

>
> Best wishes
> Kristoffer Ericson
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
