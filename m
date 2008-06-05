Return-Path: <linux-kernel-owner+w=401wt.eu-S1762696AbYFEBLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762696AbYFEBLx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 21:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbYFEBLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 21:11:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:48075 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742AbYFEBLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 21:11:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,592,1204531200"; 
   d="scan'208";a="572640256"
Subject: Re: [patch -v3 16/22] acpi: use memory_read_from_buffer
From: Zhao Yakui <yakui.zhao@intel.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org
In-Reply-To: <20080604115824.062644468@gmail.com>
References: <20080604115633.116832712@gmail.com>
	 <20080604115824.062644468@gmail.com>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 09:21:26 +0800
Message-Id: <1212628886.10730.2.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-04 at 20:56 +0900, Akinobu Mita wrote:
> plain text document attachment
> (acpi-use-memory-read-from-buffer.patch)
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Len Brown <len.brown@intel.com>
> Cc: linux-acpi@vger.kernel.org
> ---
>  drivers/acpi/system.c |   15 ++-------------
>  1 file changed, 2 insertions(+), 13 deletions(-)
> 
> Index: 2.6-git/drivers/acpi/system.c
> ===================================================================
> --- 2.6-git.orig/drivers/acpi/system.c
> +++ 2.6-git/drivers/acpi/system.c
> @@ -77,7 +77,6 @@ static ssize_t acpi_table_show(struct ko
>  	    container_of(bin_attr, struct acpi_table_attr, attr);
>  	struct acpi_table_header *table_header = NULL;
>  	acpi_status status;
> -	ssize_t ret_count = count;
>  
>  	status =
>  	    acpi_get_table(table_attr->name, table_attr->instance,
> @@ -85,18 +84,8 @@ static ssize_t acpi_table_show(struct ko
>  	if (ACPI_FAILURE(status))
>  		return -ENODEV;
>  
> -	if (offset >= table_header->length) {
> -		ret_count = 0;
> -		goto end;
> -	}
> -
> -	if (offset + ret_count > table_header->length)
> -		ret_count = table_header->length - offset;
> -
> -	memcpy(buf, ((char *)table_header) + offset, ret_count);
> -
> -      end:
> -	return ret_count;
> +	return memory_read_from_buffer(buf, count, &offset,
> +					table_header, table_header->length);
>  }
it seems that there is no definition of memory_read_from_buffer. 
Where is the function of memory_read_from_buffer defined?
Is there a bug about the current function of acpi_table_show?
Thanks.
>  
>  static void acpi_table_attr_init(struct acpi_table_attr *table_attr,
> 

