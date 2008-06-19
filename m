Return-Path: <linux-kernel-owner+w=401wt.eu-S1757631AbYFSIJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbYFSIJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 04:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756249AbYFSIJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 04:09:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:44299 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649AbYFSIJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 04:09:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VAeoEQYJWrLUyeHrEkg9v+PW8cwpZh9snMqzTNPul0k6xGlWSLYN231BRqxD0UbzYV
         wmCBwfq1JIqaVX1xDdStFIJO6ql+Rje69mZw52yhxLNRQvnY5CrjnyGC6Tp2Dtdl12u5
         VNVps7W7o5ZVWQDzb+0gIWLdpV6l2WOk+n2pY=
Message-ID: <6101e8c40806190109u279a713dn5b0264ab235e53c@mail.gmail.com>
Date: Thu, 19 Jun 2008 10:09:15 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Len Brown" <lenb@kernel.org>
Subject: Re: [stable PATCH 2.6.21] ACPICA: Ignore ACPI table signature for Load() operator
Cc: stable@kernel.org, linux-acpi@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0806182211330.3613@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0806182211330.3613@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thx picked up for 2.6.22

On 6/19/08, Len Brown <lenb@kernel.org> wrote:
> From: Bob Moore <robert.moore@intel.com>
>
> upstream bc45b1d39a925b56796bebf8a397a0491489d85c
>
> Only "SSDT" is acceptable to the ACPI spec, but tables are
> seen with OEMx and null sigs. Therefore, signature validation
> is worthless.  Apparently MS ACPI accepts such signatures, ACPICA
> must be compatible.
>
> Without this patch booting with acpi_osi="!Windows 2006" is required
> for several machines to function properly with cpufreq.
>
> http://bugzilla.kernel.org/show_bug.cgi?id=9919
> http://bugzilla.kernel.org/show_bug.cgi?id=10383
> http://bugzilla.kernel.org/show_bug.cgi?id=10454
> https://bugzilla.novell.com/show_bug.cgi?id=396311
>
> Signed-off-by: Bob Moore <robert.moore@intel.com>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  drivers/acpi/tables/tbinstal.c |   25 +++++++------------------
>  1 files changed, 7 insertions(+), 18 deletions(-)
>
> Index: linux-2.6.21.y/drivers/acpi/tables/tbinstal.c
> ===================================================================
> --- linux-2.6.21.y.orig/drivers/acpi/tables/tbinstal.c
> +++ linux-2.6.21.y/drivers/acpi/tables/tbinstal.c
> @@ -123,17 +123,13 @@ acpi_tb_add_table(struct acpi_table_desc
>  		}
>  	}
>
> -	/* The table must be either an SSDT or a PSDT */
> -
> -	if ((!ACPI_COMPARE_NAME(table_desc->pointer->signature, ACPI_SIG_PSDT))
> -	    &&
> -	    (!ACPI_COMPARE_NAME(table_desc->pointer->signature, ACPI_SIG_SSDT)))
> -	{
> -		ACPI_ERROR((AE_INFO,
> -			    "Table has invalid signature [%4.4s], must be SSDT or PSDT",
> -			    table_desc->pointer->signature));
> -		return_ACPI_STATUS(AE_BAD_SIGNATURE);
> -	}
> +	/*
> +	 * Originally, we checked the table signature for "SSDT" or "PSDT" here.
> +	 * Next, we added support for OEMx tables, signature "OEM".
> +	 * Valid tables were encountered with a null signature, so we've just
> +	 * given up on validating the signature, since it seems to be a waste
> +	 * of code. The original code was removed (05/2008).
> +	 */
>
>  	(void)acpi_ut_acquire_mutex(ACPI_MTX_TABLES);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
