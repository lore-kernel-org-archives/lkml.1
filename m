Return-Path: <linux-kernel-owner+w=401wt.eu-S1161194AbXDQT76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161194AbXDQT76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 15:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161209AbXDQT76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 15:59:58 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:38680 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161194AbXDQT75 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 15:59:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=PGPamUPfIwb7EPe+AV1U6KbFIfKBdjTPGC/pdKo3g39sRQkTBq61+6+mn5Kp9bbu79rnNlbY4xgxFv648BJAw5hFbklEhuTzhXbayKl8K/AKX4eYX3A6dLQELi2BtE7yoLRXbc/F97g/1HaSj80lRQhWoj64fd57YWepTFg32cc=
Message-ID: <4354d3270704171259w6110f678ldfec7da3f264d111@mail.gmail.com>
Date: Tue, 17 Apr 2007 22:59:55 +0300
From: "=?ISO-8859-1?Q?T=F6r=F6k_Edvin?=" <edwintorok@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: SOLVED: Unable to add subdirectory: Ooops in sys_add_file, called from kobject_register
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/07, Török Edvin <edwintorok@gmail.com> wrote:
>
> I got an Ooops while trying to load a little kernel module I wrote.
> [....]
> /* Attributes changeable via sysfs */
> static struct attribute * default_attrs[] = {
>         &module_enabled.attr,
>         &wbinvd_execute.attr,
>         &algnment_checks.attr
+         , NULL
> };

I was missing a NULL terminating entry here.

>
> static struct kobject* control_kobject[NR_CPUS];
>  [...]
>         control_kobject[cpu] = kzalloc(sizeof(control_kobject[0]), GFP_KERNEL);

I was missing a * here, so I ended up allocating fewer bytes.
Correctly that line should read:
+        control_kobject[cpu] = kzalloc(sizeof(*control_kobject[0]),
GFP_KERNEL);

Now the module works on Core Duo too.
Posting this message to this list, just in case somebody else ends up
doing the same mistakes I did.

Edwin
