Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbYAHUXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbYAHUXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 15:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbYAHUWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 15:22:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696AbYAHUWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 15:22:51 -0500
Date: Tue, 8 Jan 2008 15:22:45 -0500
From: Rik van Riel <riel@redhat.com>
To: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
Cc: "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, gorcunov@gmail.com
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Message-ID: <20080108152245.3a8b415f@bree.surriel.com>
In-Reply-To: <4d8e3fd30801081158j3e7292d0i939776342015b12d@mail.gmail.com>
References: <20080108164015.GC31504@one.firstfloor.org>
	<4d8e3fd30801081158j3e7292d0i939776342015b12d@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008 20:58:04 +0100
"Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com> wrote:

> -static const struct file_operations rtc_fops = {
> +static long rtc_fioctl(struct file_operations rtc_fops)
> +{
> +	lock_kernel();
>  	.owner		= THIS_MODULE,
>  	.llseek		= no_llseek,
>  	.read		= rtc_read,
>  	.poll		= rtc_poll,
> -	.ioctl		= rtc_ioctl,
> +	.unlocked_ioctl	= rtc_ioctl,
>  	.open		= rtc_open,
>  	.release	= rtc_release,
>  	.fasync		= rtc_fasync,
> +	unlock_kernel();
>  };

This is a struct with function pointers, not a function.

No wonder it doesn't compile after you tried turning it into one :)

-- 
All rights reversed.
