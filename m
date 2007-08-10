Return-Path: <linux-kernel-owner+w=401wt.eu-S934987AbXHJMi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934987AbXHJMi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 08:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753711AbXHJMiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 08:38:20 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:35426 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbXHJMiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 08:38:19 -0400
Date: Fri, 10 Aug 2007 14:39:27 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Cc: "Pavel Emelyanov" <xemul@openvz.org>, "Greg KH" <gregkh@suse.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, devel@openvz.org
Subject: Re: [PATCH] Fix OOPS in show_uevent()
Message-ID: <20070810143927.619d0640@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <3ae72650708100523w45b4d5cbxf0ffbdc11cfb5e45@mail.gmail.com>
References: <46BC3A57.5070404@openvz.org>
	<3ae72650708100523w45b4d5cbxf0ffbdc11cfb5e45@mail.gmail.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2007 14:23:56 +0200,
"Kay Sievers" <kay.sievers@vrfy.org> wrote:

> But we still don't update the remaining buffer size and the remaining
> array fields which are left after the call. Shouldn't we instead just
> change the:
>    int (*dev_uevent)(struct device *dev,
>                                 char **envp, int num_envp,
>                                 char *buffer, int buffer_size);
> to:
>   int (*dev_uevent)(struct device *dev,
>                                char **envp, int num_envp, int *cur_index,
>                                char *buffer, int buffer_size, int *cur_len);
> 
> like we do for:
>   int add_uevent_var(char **envp, int num_envp, int *cur_index,
>                                   char *buffer, int buffer_size, int *cur_len,
>                                   const char *format, ...)
> 
> and along with the change of the callers, we would update the values
> properly, so the next call has the correct numbers? There are 6
> classes and something like 12 buses using this method, so it shouldn't
> be too much trouble.

Sounds like a sensible approach. We may want the remaining non-users to
add_uevent_var() at the same time, I guess.
