Return-Path: <linux-kernel-owner+w=401wt.eu-S1764298AbYF3Tfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764298AbYF3Tfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762370AbYF3Tfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:35:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761471AbYF3Tf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:35:29 -0400
Date: Mon, 30 Jun 2008 12:34:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Justin Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, linux-acpi@vger.kernel.org,
       Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
Subject: Re: GPE storm detected, disabling EC GPE
Message-Id: <20080630123454.7f48b7e0.akpm@linux-foundation.org>
In-Reply-To: <dd18b0c30806051401j28a57871ke4e1c76a4c8ea425@mail.gmail.com>
References: <dd18b0c30806051401j28a57871ke4e1c76a4c8ea425@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2008 21:01:55 +0000
"Justin Mattock" <justinmattock@gmail.com> wrote:

> FWIW I noticed a post where the person had changed 5 to 20, and it
> seemed to work for them;
> So with that in mind I decide to give that a go, here is the location:
> drivers/acpi/ec.c
> @@ -527,47 +488,51 @@ static u32 acpi_ec_gpe_handler(void *data)
>  {
>         acpi_status status = AE_OK;
>         struct acpi_ec *ec = data;
>        u8 state = acpi_ec_read_status(ec);
> 
>         pr_debug(PREFIX "~~~> interrupt\n");
>        atomic_inc(&ec->irq_count);
> -       if (atomic_read(&ec->irq_count) > 5) {
> +       if (atomic_read(&ec->irq_count) > 20) {
>                pr_err(PREFIX "GPE storm detected, disabling EC GPE\n");
>                ec_switch_to_poll_mode(ec);
>                goto end;
>        }
> 
> Now I don't know if this will work for other brands, but for
> me(Macbook Pro ATI chipset) I have not received the
> GPE storm detected, disabling EC GPE message, but it's only been an
> hour, maybe after two or three this might appear.
> Also is this good or bad to set 5 to 20 for the system?
> regards;

We've had a few reports of this GPE-storm problem and I've rather lost
track of what's happening.  Has anyone looked into it?

If not, do we have a bugzilla report where we can work on this?

Thanks.
