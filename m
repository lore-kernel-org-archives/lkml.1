Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbZBKXxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbZBKXxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 18:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbZBKXxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 18:53:30 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:6573 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbZBKXx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 18:53:29 -0500
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <499364EE.1030400@tremplin-utc.net>
Date: Thu, 12 Feb 2009 00:53:18 +0100
From: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081231 Mandriva/2.0.0.19-1mdv2009.1 (2009.1) Thunderbird/2.0.0.19 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>,
       linux-kernel@vger.kernel.org, pavel@suse.cz
Subject: Re: [PATCHv7] lis3lv02d: support both one- and two-byte sensors
References: <49929EB8.4020802@tremplin-utc.net>	<1234346803-19811-1-git-send-email-giuseppe.bilotta@gmail.com> <20090211143844.27ca0d6c.akpm@linux-foundation.org>
In-Reply-To: <20090211143844.27ca0d6c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton schreef:
> Also, this comment:
> 
> /*
>  * The sensor can also generate interrupts (DRDY) but it's pretty pointless
>  * because their are generated even if the data do not change. So it's better
>  * to keep the interrupt for the free-fall event. The values are updated at
>  * 40Hz (at the lowest frequency), but as it can be pretty time consuming on
>  * some low processor, we poll the sensor only at 20Hz... enough for the
>  * joystick.
>  */
> 
> seems to be describing something which isn't there.
Actually it's describing the main architecture of the driver, and wa put 
at this place due to the two lines just _above_ this comment:
/* joystick device poll interval in milliseconds */
#define MDPS_POLL_INTERVAL 50
A poll of 50 ms = 20Hz. And it's there to explain why I decided to use 
polling although in the documentation they say that interrupt can be 
generated whenever data is updated. (even if in general it's better to 
use interrupt driven than polling based)

Suggestions are welcome to make this comment more understandable :-)

Eric
