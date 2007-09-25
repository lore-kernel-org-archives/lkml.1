Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbXIYLEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbXIYLEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 07:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbXIYLEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 07:04:34 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:42059 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbXIYLEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 07:04:33 -0400
Message-ID: <46F8EB26.2090104@linux.vnet.ibm.com>
Date: Tue, 25 Sep 2007 16:34:06 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: richard kennedy <richard@rsk.demon.co.uk>, sct@redhat.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: jbd : config_jbd_debug cannot create /proc entry
References: <1190713240.3154.20.camel@castor.rsk.org> <20070925105112.GB8126@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20070925105112.GB8126@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Jan Kara wrote:
>> 
> -#define create_jbd_proc_entry() do {} while (0)
> -#define remove_jbd_proc_entry() do {} while (0)
> +static ctl_table fs_table[] = {
> +	{
> +                .ctl_name       = -1,	/* Don't want it */



shouldn't this be CTL_UNNUMBERED ?


> +                .procname       = "jbd-debug",
> +                .data           = &journal_enable_debug,
> +                .maxlen         = sizeof(int),
> +                .mode           = 0644,
> +                .proc_handler   = &proc_dointvec,
> +        },
> +        { .ctl_name = 0 },
> +};
>

-aneesh
