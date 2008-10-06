Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbYJFGon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbYJFGon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 02:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbYJFGoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 02:44:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:63682 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbYJFGod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 02:44:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=aJTI7YRaDgxLNhWdieWdnLK8uoFvTbbQOVbo9E1yPiBvU4dtryYtlPwHjSSKHb7XHf
         9Ufi+Tjs0nluRSkExzwWAMy/CqVfw4s8XbQA6htstJpYnVVdLpyHyP2rGMzRMYA+65Fm
         q1Rsaz+Rl7kQiEutKakaPx6c5TEPzM422pHxk=
Message-ID: <84144f020810052344x5b90c22fjd7b984e1d2dddde2@mail.gmail.com>
Date: Mon, 6 Oct 2008 09:44:33 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Alex Chiang" <achiang@hp.com>
Subject: Re: [PATCH v4 11/15] PCI: rpaphp: kmalloc/kfree slot->name directly
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20081003231823.9989.50968.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081003230125.9989.31145.stgit@bob.kio>
	 <20081003231823.9989.50968.stgit@bob.kio>
X-Google-Sender-Auth: 983912ceba03feb2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 4, 2008 at 2:18 AM, Alex Chiang <achiang@hp.com> wrote:
> @@ -63,10 +63,9 @@ struct slot *alloc_slot_struct(struct device_node *dn,
>                                           GFP_KERNEL);
>        if (!slot->hotplug_slot->info)
>                goto error_hpslot;
> -       slot->hotplug_slot->name = kmalloc(strlen(drc_name) + 1, GFP_KERNEL);
> -       if (!slot->hotplug_slot->name)
> +       slot->name = kmalloc(strlen(drc_name) + 1, GFP_KERNEL);
> +       if (!slot->name)
>                goto error_info;
> -       slot->name = slot->hotplug_slot->name;
>        strcpy(slot->name, drc_name);

Minor nit: you could use kstrdup() here.
