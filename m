Return-Path: <linux-kernel-owner+w=401wt.eu-S1753124AbZITWk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbZITWk6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 18:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752669AbZITWk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 18:40:58 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:60642 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbZITWk5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 18:40:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Y1rZNDcuWCcqLVvNQsrJILtTTM9EnYzs9VV3yQ4/KCYKng/oic9KELDFlankL09fd4
         4wNshDj19VML0gi0v0JYAnUZA015fQmJd0KP4Uvglzu0OCjtgKZOKCvv9ewCIgOf5LJ/
         kGJVcL9gaJ0r2Wmcav3kIIQbk6mh9eexV9rd0=
MIME-Version: 1.0
In-Reply-To: <20090919233044.8361a912.akpm@linux-foundation.org>
References: <1253211850-29309-1-git-send-email-vapier@gentoo.org> 
	<20090919233044.8361a912.akpm@linux-foundation.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 20 Sep 2009 18:40:41 -0400
Message-ID: <8bd0f97a0909201540t25dd2337o15ebe63a2a9ca4ec@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH] input/keyboard: new driver for 
	ADP5520 MFD PMICs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Hennerich <michael.hennerich@analog.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 20, 2009 at 02:30, Andrew Morton wrote:
> On Thu, 17 Sep 2009 14:24:10 -0400 Mike Frysinger wrote:
>> +struct adp5520_keys {
>> +     struct input_dev *input;
>> +     struct notifier_block notifier;
>> +     struct device *master;
>> +     unsigned short keycode[ADP5520_KEYMAPSIZE];
>
> Where is ADP5520_KEYMAPSIZE defined?

all these things are in the common mfd adp5520 patch.  it introduces a
common adp5520 header.

>> +     for (i = 0; i < ADP5520_MAXKEYS; i++)
>> +             if (keymask & (1 << i))
>> +                     input_report_key(dev->input, dev->keycode[i], value);
>
> It seems odd that keycode is dimensioned with ADP5520_KEYMAPSIZE but
> here we iterate up to ADP5520_MAXKEYS.

ARRAY_SIZE() probably makes more sense
-mike
