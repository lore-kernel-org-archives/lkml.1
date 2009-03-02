Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbZCBWdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbZCBWdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 17:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbZCBWd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 17:33:29 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:35767 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbZCBWd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 17:33:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Z4+5EW02WfLeMk1ZIUAodoRdaaE+G8PaLIlALgFuY7jAe0XKkb+4Jz64l9Vg/Ebwkv
         j4+Rt/o6fBDZjYVIHOi2hd9DT3q8Mf5vrViPNTh4s64imqVMNMRYoUWQd6lbXyFYbLTT
         Ohp6c475IynhGrnnf+/GhRRgiB54Cgbwv5BoE=
Message-ID: <49AC5EB2.3050805@gmail.com>
Date: Mon, 02 Mar 2009 23:33:22 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Subject: Re: [PATCH 2/2] Input: add wm97xx accelerated driver for AVR32 AT32AP700X
 microprocessors
References: <1236000228-13025-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1236000228-13025-2-git-send-email-broonie@opensource.wolfsonmicro.com> <49ABEE83.904@gmail.com>
In-Reply-To: <49ABEE83.904@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.3.2009 15:34, Jiri Slaby wrote:
>> +static int at32_wm97xx_suspend(struct platform_device *pdev,
>> pm_message_t msg)
>> +{
>> + struct at32_wm97xx *at32_wm97xx = platform_get_drvdata(pdev);
>> +
>> + ac97c_writel(at32_wm97xx, IDR, AC97C_INT_CBEVT);
>> + disable_irq(at32_wm97xx->gpio_irq);
>
> Here, you should call disable_irq_sync() (that's what I meant by _sync
> in the last post).

Ah, it's in the opposite way. This one is fine, the patch 1/2 should use 
disable_irq_nosync(), if I understand the code correctly.

