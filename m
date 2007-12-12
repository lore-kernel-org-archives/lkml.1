Return-Path: <linux-kernel-owner+w=401wt.eu-S1759056AbXLLKrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759056AbXLLKrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 05:47:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbXLLKrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 05:47:39 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43578 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755517AbXLLKri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 05:47:38 -0500
Date: Wed, 12 Dec 2007 02:47:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Adam Jackson <ajax@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] apm_event{,info}_t are userspace types.
Message-Id: <20071212024700.19560b60.akpm@linux-foundation.org>
In-Reply-To: <1196452963295-git-send-email-ajax@redhat.com>
References: <1196452963295-git-send-email-ajax@redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007 15:02:43 -0500 Adam Jackson <ajax@redhat.com> wrote:

> These types define the size of data read from /dev/apm_bios.  They
> should not be hidden behind #ifdef __KERNEL__.

Missing info: what are the consequences of this fix?  What id broken when
it it not applied?


> ---
>  include/linux/apm_bios.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)

Please include Signed-off-by:, as per Documentation/SubmittingPatches,
thanks.

> diff --git a/include/linux/apm_bios.h b/include/linux/apm_bios.h
> index 9754baa..01a6244 100644
> --- a/include/linux/apm_bios.h
> +++ b/include/linux/apm_bios.h
> @@ -18,6 +18,9 @@
>  
>  #include <linux/types.h>
>  
> +typedef unsigned short	apm_event_t;
> +typedef unsigned short	apm_eventinfo_t;
> +
>  struct apm_bios_info {
>  	__u16	version;
>  	__u16	cseg;
> @@ -32,9 +35,6 @@ struct apm_bios_info {
>  
>  #ifdef __KERNEL__
>  
> -typedef unsigned short	apm_event_t;
> -typedef unsigned short	apm_eventinfo_t;
> -
>  #define APM_CS		(GDT_ENTRY_APMBIOS_BASE * 8)
>  #define APM_CS_16	(APM_CS + 8)
>  #define APM_DS		(APM_CS_16 + 8)

