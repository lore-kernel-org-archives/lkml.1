Return-Path: <linux-kernel-owner+w=401wt.eu-S1752429AbZIPD5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbZIPD5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 23:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbZIPD5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 23:57:49 -0400
Received: from mail-yw0-f180.google.com ([209.85.211.180]:56920 "EHLO
	mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbZIPD5t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 23:57:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=AXxq39dQ8IqdWNlHOquFP/KUpMZmbIM0GnwM/gLpsfyLw+ge7mtuMf0wLfUfpWLepv
         xaEEpcTP5tvj5NZnxR9Sdet8WwzGUmHxcSlRj8nneDPWWamEYaKNn+UyByaDK95/Pn5X
         0kJK9sXciXfpdTaYC76fur+ZdgwKbDeZTC/Mw=
MIME-Version: 1.0
In-Reply-To: <20090916034555.GA2756@core.coreip.homeip.net>
References: <20090915055224.GD1132@core.coreip.homeip.net> 
	<1253066440-25555-1-git-send-email-vapier@gentoo.org> <20090916034555.GA2756@core.coreip.homeip.net>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 15 Sep 2009 23:57:32 -0400
Message-ID: <8bd0f97a0909152057v2049371aif4118691d56165c8@mail.gmail.com>
Subject: Re: [PATCH v4] input/keyboard: new OpenCores Keyboard Controller 
	driver
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Javier Herrero <jherrero@hvsistemas.es>, Bryan Wu <cooloney@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 23:45, Dmitry Torokhov wrote:
> On Tue, Sep 15, 2009 at 10:00:40PM -0400, Mike Frysinger wrote:
>> +
>> +static int __devexit opencores_kbd_remove(struct platform_device *pdev)
>> +{
>> +     struct opencores_kbd *opencores_kbd = platform_get_drvdata(pdev);
>> +
>> +     free_irq(opencores_kbd->irq, opencores_kbd);
>> +
>> +     input_unregister_device(opencores_kbd->input);
>> +     kfree(opencores_kbd);
>
> You need to do iounmap and free the memory region here as well.

ugh, i remembered i would have to do this while writing the initial
code, but forgot while double checking the different error paths
-mike
