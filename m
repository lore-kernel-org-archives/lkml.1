Return-Path: <linux-kernel-owner+w=401wt.eu-S1756412AbXJXRTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbXJXRTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbXJXRTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:19:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:36430 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbXJXRTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:19:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=T5amex2M2M6GBfbGFa4uo7XFJXjAYLVQfVmY8prwX75xvlCCTAiG72/fwZOm56+3fUCQN6R8rl3Q9wmjbapSnNVtLDaa6rZ+JM/3EcFQT3yCvUUxLnOR96vb6/yJbULLrIWnY40HIizk4FbBelOMxD9j+LtX9drZqAr4qLomAdA=
Message-ID: <471F7E7D.1080501@gmail.com>
Date: Wed, 24 Oct 2007 21:18:53 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] acpi/battery.c: remove dead code
References: <20071024162537.GA30533@stusta.de>
In-Reply-To: <20071024162537.GA30533@stusta.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> After commit f1d4661abe05d0a2c014166042d15ed8b69ae8f2 this was dead 
> code.
> 
> Spotted by the Coverity checker.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked. Thanks.
> 
> ---
> --- linux-2.6/drivers/acpi/battery.c.old	2007-10-23 18:44:13.000000000 +0200
> +++ linux-2.6/drivers/acpi/battery.c	2007-10-23 18:44:43.000000000 +0200
> @@ -550,18 +550,14 @@ static ssize_t acpi_battery_write_alarm(
>  	int result = 0;
>  	char alarm_string[12] = { '\0' };
>  	struct seq_file *m = file->private_data;
>  	struct acpi_battery *battery = m->private;
>  
>  	if (!battery || (count > sizeof(alarm_string) - 1))
>  		return -EINVAL;
> -	if (result) {
> -		result = -ENODEV;
> -		goto end;
> -	}
>  	if (!acpi_battery_present(battery)) {
>  		result = -ENODEV;
>  		goto end;
>  	}
>  	if (copy_from_user(alarm_string, buffer, count)) {
>  		result = -EFAULT;
>  		goto end;
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

