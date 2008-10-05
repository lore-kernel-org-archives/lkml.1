Return-Path: <linux-kernel-owner+w=401wt.eu-S1757218AbYJEQcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbYJEQcb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759281AbYJEQYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:24:00 -0400
Received: from senator.holtmann.net ([87.106.208.187]:33143 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758477AbYJEQX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:23:59 -0400
Subject: Re: [PATCH 2.6.28] bluetooth: fix leak of uninitialized data to
	userspace
From: Marcel Holtmann <marcel@holtmann.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081005153836.GA15807@localhost.localdomain>
References: <20081005153836.GA15807@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 05 Oct 2008 18:24:15 +0200
Message-Id: <1223223855.11272.104.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vegard,

> From 45be27894a18f87b71b855fcc4afd50f860254b4 Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Sun, 5 Oct 2008 17:25:45 +0200
> Subject: [PATCH] bluetooth: fix leak of uninitialized data to userspace
> 
>     struct hci_dev_list_req {
>             __u16  dev_num;
>             struct hci_dev_req dev_req[0];  /* hci_dev_req structures */
>     };
> 
> sizeof(struct hci_dev_list_req) == 4, so the two bytes immediately
> following "dev_num" will never be initialized. When this structure
> is copied to userspace, these uninitialized bytes are leaked.
> 
> Fix by using kzalloc() instead of kmalloc(). Found using kmemcheck.

good catch. I thought we moved everything over to kzalloc, but as it
seems we forgot at least one. Applied your patch to me tree. Thanks.

Regards

Marcel


