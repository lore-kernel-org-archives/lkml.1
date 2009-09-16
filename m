Return-Path: <linux-kernel-owner+w=401wt.eu-S1757967AbZIPRTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967AbZIPRTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 13:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbZIPRTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 13:19:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53393
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752543AbZIPRTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 13:19:08 -0400
Date: Wed, 16 Sep 2009 10:19:24 -0700 (PDT)
Message-Id: <20090916.101924.186960949.davem@davemloft.net>
To: tabbott@ksplice.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, sam@ravnborg.org,
       geofft@ksplice.com
Subject: Re: [PATCH v2] sparc: Clean up linker script using new linker
 script macros.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1253119592-19598-2-git-send-email-tabbott@ksplice.com>
References: <1253119592-19598-1-git-send-email-tabbott@ksplice.com>
	<1253119592-19598-2-git-send-email-tabbott@ksplice.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Abbott <tabbott@ksplice.com>
Date: Wed, 16 Sep 2009 12:46:32 -0400

> @@ -51,70 +51,27 @@ SECTIONS
>  	_etext = .;
>  
>  	RO_DATA(PAGE_SIZE)
> -	.data :	{
> -		DATA_DATA
> -		CONSTRUCTORS
> -	}
>  	.data1 : {
>  		*(.data1)
>  	}
> -	. = ALIGN(SMP_CACHE_BYTES);
> -	.data.cacheline_aligned : {
> -		*(.data.cacheline_aligned)
> -	}
> -	. = ALIGN(SMP_CACHE_BYTES);
> -	.data.read_mostly : {
> -		*(.data.read_mostly)
> -	}
> +	RW_DATA_SECTION(SMP_CACHE_BYTES, 0, THREAD_SIZE)
> +

Can you do this cleanup without moving the relative locations of .data
and .data1 sections?
