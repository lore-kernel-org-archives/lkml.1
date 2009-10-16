Return-Path: <linux-kernel-owner+w=401wt.eu-S1751862AbZJPEhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbZJPEhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 00:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZJPEhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 00:37:00 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:35235 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbZJPEg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 00:36:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QxCI2ESH3EKZbNHvmJX+3BVDgPjdb4GFbHl+qHZX+UOpNO7N6KEsFWXykpLgE02qE0
         4zPScMAKva1f9e6ccjq62ZU74+sgHc692+o6VxVtosDb+B+/4wrFXFChUvnVi0/slSW1
         ZLD6hrm2cBfWIjDQfBOMidE9rNqy3X0fI0oEg=
Date: Thu, 15 Oct 2009 21:36:18 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alex Chiang <achiang@hp.com>
Cc: lenb@kernel.org, shaohua.li@intel.com, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 1/6] ACPI: dock: clean up error handling paths in
	dock_add()
Message-ID: <20091016043618.GB11582@core.coreip.homeip.net>
References: <20091014224415.18044.88208.stgit@bob.kio> <20091014224616.18044.45719.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014224616.18044.45719.stgit@bob.kio>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Wed, Oct 14, 2009 at 04:46:16PM -0600, Alex Chiang wrote:
> Remove some copy/paste code in our error handling paths, which makes
> the function smaller and slightly easier to read.

Changing individual attributes into attribute_group would greatly
simplify the code.

> 
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> 
>  drivers/acpi/dock.c |   75 +++++++++++++++++++--------------------------------
>  1 files changed, 28 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
> index 7338b6a..642c7dd 100644
> --- a/drivers/acpi/dock.c
> +++ b/drivers/acpi/dock.c
> @@ -968,11 +968,9 @@ static int dock_add(acpi_handle handle)
>  		platform_device_register_simple(dock_device_name,
>  			dock_station_count, NULL, 0);
>  	dock_device = dock_station->dock_device;
> -	if (IS_ERR(dock_device)) {
> -		kfree(dock_station);
> -		dock_station = NULL;
> -		return PTR_ERR(dock_device);
> -	}
> +	ret = IS_ERR(dock_device) ? PTR_ERR(dock_device) : 0;
> +	if (ret)
> +		goto out;

I think

	if (IS_ERR(dock_device)) {
		ret = PTR_ERR(dock_device);
		goto out;
	}

is more commonly used form.

Thanks.

-- 
Dmitry
