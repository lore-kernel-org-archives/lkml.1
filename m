Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbZFGI5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbZFGI5h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 04:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbZFGI5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 04:57:30 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:41115 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039AbZFGI5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 04:57:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=S+ScV0jjO/yU5A4zbbCdXSRXSo5BFL8wgH8VV4nn4hXkk2ZJg4rEEQ9/9hRxtZopgC
         vDwjmVp+aO0WmP85MS7ipU0QGuJR7alSI83F5Hc0l06O3b6smyujQquHgpk4dwHK7hHb
         3FChw+VBMQCYsO88J8W7gOUXP0LSQmKLU9Ai8=
Message-ID: <4A2B80F9.9070103@gmail.com>
Date: Sun, 07 Jun 2009 10:57:29 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.1 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, jeffrey.mitchell@gmail.com
Subject: Re: [PATCH] dmi: sanity check BIOS tables
References: <20090606230137.17029.51286.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090606230137.17029.51286.stgit@t61.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2009 01:01 AM, Alan Cox wrote:
> @@ -260,6 +276,11 @@ static void __init dmi_save_ipmi_device(const struct dmi_header *dm)
>  	struct dmi_device *dev;
>  	void * data;
>  
> +	if (((u8 *)dm) + dm->length > dmi_end) {

I think this should be >= too.

> +		printk(KERN_ERR "dmi_save_ipmi_device: table overrun.\n");
> +		return;
> +	}
> +
