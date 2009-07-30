Return-Path: <linux-kernel-owner+w=401wt.eu-S1751306AbZG3Oyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbZG3Oyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 10:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbZG3Oye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 10:54:34 -0400
Received: from www.tglx.de ([62.245.132.106]:46518 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbZG3Oye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 10:54:34 -0400
Message-ID: <4A71B401.1090208@linutronix.de>
Date: Thu, 30 Jul 2009 16:53:53 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Stoyan Gaydarov <sgayda2@uiuc.edu>
CC: vimal singh <vimal.newwork@gmail.com>, linux-kernel@vger.kernel.org,
       David.Woodhouse@intel.com, sr@denx.de, kay.sievers@vrfy.org,
       gregkh@suse.de, linux-mtd@lists.infradead.org
Subject: Re: [PATCH] [mtd] fixed faulty check
References: <1248958178-22599-1-git-send-email-sgayda2@uiuc.edu> 	<4A719A27.8050509@linutronix.de> <ce9ab5790907300639k3173446csbd07198055bfe122@mail.gmail.com> 	<4A71A483.30507@linutronix.de> <ce9ab5790907300714u5c88f1cdk8c0387de5ba9f413@mail.gmail.com> <4A71AD5E.4080704@uiuc.edu>
In-Reply-To: <4A71AD5E.4080704@uiuc.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stoyan Gaydarov wrote:
>>> We have to and of_flash_remove() takes care of it.
>>>     
>>   
> Does this mean that the original patch is fine or does it still need the 
> kfree? From what i understand when going to err_out it will take care of 
> info using of_flash_remove() so then it is not needed in the if check.

The original patch was fine but it leaked info. of_flash_remove() does the
cleanup of info but only if it is part of driver's data (after the
of_flash_remove()). So you have to call dev_set_drvdata(&dev->dev, info)
earlier, after the kzalloc() to save the data or else there is no clean
up.

> -Stoyan

Sebastian
