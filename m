Return-Path: <linux-kernel-owner+w=401wt.eu-S1758380AbZHRAHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380AbZHRAHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 20:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbZHRAHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 20:07:24 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57607 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbZHRAHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 20:07:24 -0400
Subject: Re: [patch 3/3] flex_array: declare parts member to have
 incomplete type
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0908171645520.30313@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908171644540.30313@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0908171645520.30313@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 17:07:23 -0700
Message-Id: <1250554043.10725.22015.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-17 at 16:46 -0700, David Rientjes wrote:
> The `parts' member of struct flex_array should evaluate to an incomplete
> type so that sizeof() cannot be used and C99 does not require the
> zero-length specification.
> 
> Cc: Dave Hansen <dave@linux.vnet.ibm.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  include/linux/flex_array.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/flex_array.h b/include/linux/flex_array.h
> --- a/include/linux/flex_array.h
> +++ b/include/linux/flex_array.h
> @@ -21,7 +21,7 @@ struct flex_array {
>  		struct {
>  			int element_size;
>  			int total_nr_elements;
> -			struct flex_array_part *parts[0];
> +			struct flex_array_part *parts[];
>  		};
>  		/*
>  		 * This little trick makes sure that

That's a good little trick.  I don't see any downside to it. 

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

-- Dave

