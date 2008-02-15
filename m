Return-Path: <linux-kernel-owner+w=401wt.eu-S1763031AbYBOCAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763031AbYBOCAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 21:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbYBOCAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 21:00:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58691 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754694AbYBOCAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 21:00:01 -0500
Message-ID: <47B4F1C5.9010408@cn.fujitsu.com>
Date: Fri, 15 Feb 2008 09:58:29 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Kohei KaiGai <kaigai@ak.jp.nec.com>
CC: akpm@osdl.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       "Andrew G. Morgan" <morgan@kernel.org>, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       adobriyan@gmail.com
Subject: Re: [PATCH] exporting capability code/name pairs (try #5)
References: <47997122.3070504@ak.jp.nec.com> <479990A1.3050103@kernel.org> <4799CAE0.7010400@ak.jp.nec.com> <47A2AB60.5000403@ak.jp.nec.com> <20080204162103.GA20130@sergelap.ibm.com> <47A91B00.9080301@ak.jp.nec.com> <20080206050805.GD3258@sergelap.austin.ibm.com> <47AC23F1.5030300@ak.jp.nec.com> <20080212180859.GA12876@sergelap.austin.ibm.com> <47B2A3F3.8060701@ak.jp.nec.com> <47B4ED1B.6070206@ak.jp.nec.com>
In-Reply-To: <47B4ED1B.6070206@ak.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kohei KaiGai wrote:

<...snip...>

> +static int __init capability_export_names(void)
> +{
> +	/* make /sys/kernel/capability */
> +	capability_kobj = kobject_create_and_add("capability", kernel_kobj);
> +	if (!capability_kobj)
> +		goto error0;
> +
> +	/* make /sys/kernel/capability/names */
> +	if (sysfs_create_group(capability_kobj,
> +			       &capability_name_attr_group))
> +		goto error1;
> +
> +	/* make /sys/kernel/capability/codes */
> +	if (sysfs_create_group(capability_kobj,
> +			       &capability_code_attr_group))
> +		goto error2;
> +
> +	if (sysfs_create_file(capability_kobj,
> +			      &cap_version_attr.attr))
> +		goto error3;
> +
> +	return 0;
> +
> +error3:
> +	sysfs_remove_group(capability_kobj, &capability_code_attr_group);
> +error2:
> +	sysfs_remove_group(capability_kobj, &capability_name_attr_group);
> +error1:
> +	kobject_put(capability_kobj);
> +error0:
> +	printk(KERN_ERR "Unable to export capabilities\n");
> +
> +	return 0;

Should return -EFXXX ..

> +}
> +__initcall(capability_export_names);
> 

