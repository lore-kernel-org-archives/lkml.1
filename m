Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825Ab0CMAjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:39:36 -0500
Received: from claw.goop.org ([74.207.240.146]:33600 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932840Ab0CMAjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:39:31 -0500
Message-ID: <4B9ADEC0.60302@goop.org>
Date: Fri, 12 Mar 2010 16:39:28 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.3
MIME-Version: 1.0
To: wzt.wzt@gmail.com
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       jeremy@xensource.com
Subject: Re: [PATCH] XEN: Make handle_vcpu_hotplug_event() to check the sscanf()
 return value
References: <20100312025324.GC2712@localhost.localdomain>
In-Reply-To: <20100312025324.GC2712@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2010 06:53 PM, wzt.wzt@gmail.com wrote:
> It seems handle_vcpu_hotplug_event() not check the sscanf() return value.
>
> Signed-off-by: Zhitong Wang<zhitong.wangzt@alibaba-inc.com>
>    

Good catch, thanks.

     J

> ---
>   drivers/xen/cpu_hotplug.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/xen/cpu_hotplug.c b/drivers/xen/cpu_hotplug.c
> index 14e2d99..99773a6 100644
> --- a/drivers/xen/cpu_hotplug.c
> +++ b/drivers/xen/cpu_hotplug.c
> @@ -69,8 +69,8 @@ static void handle_vcpu_hotplug_event(struct xenbus_watch *watch,
>
>   	cpustr = strstr(node, "cpu/");
>   	if (cpustr != NULL) {
> -		sscanf(cpustr, "cpu/%u",&cpu);
> -		vcpu_hotplug(cpu);
> +		if (sscanf(cpustr, "cpu/%u",&cpu) == 1)
> +			vcpu_hotplug(cpu);
>   	}
>   }
>
>    

