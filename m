Return-Path: <linux-kernel-owner+w=401wt.eu-S1757846AbYLKUap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846AbYLKUap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 15:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756937AbYLKUag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 15:30:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756765AbYLKUaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 15:30:35 -0500
Date: Thu, 11 Dec 2008 12:29:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       jgarzik@redhat.com, a_romanescu@yahoo.co.uk, tj@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 1/2] DMI: add dmi_match
Message-Id: <20081211122912.58eb164e.akpm@linux-foundation.org>
In-Reply-To: <1228855948-22886-1-git-send-email-jirislaby@gmail.com>
References: <493E0689.6020302@garzik.org>
	<1228855948-22886-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  9 Dec 2008 21:52:27 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> 
> +/**
> + * dmi_match - compare string to the dmi field (if exists)
> + *
> + * Returns true if requested field equals to str (including NULL).
> + */

Forgot to document the arguments.  If you think it matters. (I don't).

> +static inline bool dmi_match(enum dmi_field f, const char *str)
> +{
> +	const char *info = dmi_get_system_info(f);
> +
> +	if (info == NULL || str == NULL)
> +		return info == str;
> +
> +	return !strcmp(info, str);
> +}
> +

I suspect we'd have thinner kernel if this wasn't inlined.
