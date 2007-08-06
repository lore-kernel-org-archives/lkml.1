Return-Path: <linux-kernel-owner+w=401wt.eu-S1757380AbXHFFbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbXHFFbm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 01:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbXHFFbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 01:31:32 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:47862 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbXHFFbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 01:31:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=mNTHTf47H9xtuIp1EpirBnuTs72oN8Fz6omQes1946VlGjqEI1xDZO2nwgS1qLMfHIek04xxK33kk02SO1uEwYqWytJRitQWehn3zfocuf+2xbnUXLSs7xmiXfs/O967UAICZxqzo9CBnOsnfWMD83934Zo7d+r+F/HvNx0qx1o=
Message-ID: <46B6B22C.1020609@gmail.com>
Date: Mon, 06 Aug 2007 14:31:24 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>, akpm@osdl.org, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Off-by-one in /sys/module/*/refcnt
References: <20070805134923.GA5918@martell.zuzino.mipt.ru> <3ae72650708050700p1fc2959epcc1e9307e3c64fed@mail.gmail.com>
In-Reply-To: <3ae72650708050700p1fc2959epcc1e9307e3c64fed@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
>> @@ -785,7 +785,7 @@ static ssize_t show_refcnt(struct module_attribute *mattr,
>>                            struct module *mod, char *buffer)
>>  {
>>         /* sysfs holds a reference */
>> -       return sprintf(buffer, "%u\n", module_refcount(mod)-1);
>> +       return sprintf(buffer, "%u\n", module_refcount(mod));
>>  }
> 
> It's likely caused by sysfs core changes, that opened attributes are
> no longer coupled to the refcount of modules. They used to take a
> reference.
> 
> The "holds a reference" comment should be removed along with your fix.
> Adding Tejun, to confirm this.

Yeap, that's correct.  Opening a sysfs node doesn't hold the module anymore.

Thanks.

-- 
tejun
