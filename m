Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbZAMHWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbZAMHWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 02:22:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbZAMHWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 02:22:09 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:62857 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbZAMHWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 02:22:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=E1SN9kLLvwPEMqo/55E8pXDUSN/a743LTkxMMaGjEAnEu6nKlc3YSReHWBTsMJkhkm
         76D0F1lGmf2hYUq1m0vHS7okIqW3OwaQekScLKE5+u+L2YWtpGWdv9GL1RfO1Ko7Ska+
         e3zedSTKWxjE56oBtlO8G7sVOgG69ks0ttnzg=
Subject: Re: [PATCH -tip] coda_psdev.h: extern's make no sense in userspace
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       sam@ravnborg.org, LKML <linux-kernel@vger.kernel.org>,
       gorcunov@gmail.com
In-Reply-To: <1231828614.3212.15.camel@jaswinder.satnam>
References: <1231828614.3212.15.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Mon, 12 Jan 2009 23:22:03 -0800
Message-Id: <1231831324.5405.25.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-13 at 12:06 +0530, Jaswinder Singh Rajput wrote:
> Impact: fix make headers_check warning:
> 
>  usr/include/linux/coda_psdev.h:90: extern's make no sense in userspace
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  include/linux/coda_psdev.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/coda_psdev.h b/include/linux/coda_psdev.h
> index 07ae8f8..c620958 100644
> --- a/include/linux/coda_psdev.h
> +++ b/include/linux/coda_psdev.h
> @@ -87,6 +87,8 @@ struct upc_req {
>   * Statistics
>   */
>  
> +#ifdef __KERNEL__
>  extern struct venus_comm coda_comms[];
> +#endif /* __KERNEL__ */

As this only gets used in code/inode.c, coda/psdev.c it would be nice if
a code-internal header could be found that could hold this.

This is only here due to the one use outside of psdev.c in inode.c

Harvey

