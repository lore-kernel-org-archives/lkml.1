Return-Path: <linux-kernel-owner+w=401wt.eu-S932773AbZLEBxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932773AbZLEBxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 20:53:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757565AbZLEBxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 20:53:00 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:48635 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757550AbZLEBw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 20:52:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jdXwQwmWdCS7vKJUFQ9LZkX11E9CumOp6voLhzDyif7EmTISoy9yaW6BoRDYpCsPka
         TP37llnd5706t1/FtMZCc4X4WLpGHZeQb0pXkWjY8g7YBZBjbXmb51ytnqp2p541DQzH
         fOk23J+xRPH3OCORSAPbLS8Ywma2NOs/Fy6f0=
MIME-Version: 1.0
In-Reply-To: <20091204202709.GA32347@ldl.fc.hp.com>
References: <b9df5fa10912040835k3e23702o8700d2d8ad2349a4@mail.gmail.com>
	 <20091204202709.GA32347@ldl.fc.hp.com>
Date: Sat, 5 Dec 2009 07:53:05 +0600
Message-ID: <b9df5fa10912041753n27e60020x2dd41eb50f4608ff@mail.gmail.com>
Subject: Re: [PATCH] pci: Make pci_dev struct point to NULL.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Alex Chiang <achiang@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/5/09, Alex Chiang <achiang@hp.com> wrote:
> * Rakib Mullick <rakib.mullick@gmail.com>:
>
> This is from Linus's latest tree:
>
>   974
>   975         if (slot->flags & SLOT_ENABLED)
>   976                 goto err_exit;

I'm talking about this line. From here we can hit 'goto err_exit' without
using pci_get_slot.

>   977
>   978         /* sanity check: dev should be NULL when hot-plugged in */
>   979         dev = pci_get_slot(bus, PCI_DEVFN(slot->device, 0));
>   980         if (dev) {
>
>  I assume your line 975 is my line 980.

Nope, my line 975 is also yours.
>
>  pci_get_slot() returns NULL if it doesn't find the devfn, so as
>  far as I can tell, there's no need to initialize dev to NULL.
>
>  Were you fixing a real bug with this patch? Did you actually get
>  the "pci_dev structure already exists.\n" error message?
>
No - i'm trying to make sure that we're not referencing into a trash.

>  Thanks,
>
> /ac
>
