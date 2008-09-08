Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbYIHUlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbYIHUlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 16:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbYIHUk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 16:40:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753855AbYIHUkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 16:40:55 -0400
Date: Mon, 8 Sep 2008 13:40:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: jbarnes@virtuousgeek.org, bhutchings@solarflare.com,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] PCI: vpd handle longer delays in access
Message-Id: <20080908134025.9ac23a73.akpm@linux-foundation.org>
In-Reply-To: <20080904205718.543005986@vyatta.com>
References: <20080904205636.130211023@vyatta.com>
	<20080904205718.543005986@vyatta.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Sep 2008 13:56:37 -0700
Stephen Hemminger <shemminger@vyatta.com> wrote:

> Accessing the VPD area can take a long time.  The existing 
> VPD access code fails consistently on my hardware. There are comments
> in the SysKonnect vendor driver that it can take up to 13ms per word. 
> 
> Change the access routines to:
>   * use a mutex rather than spinning with IRQ's disabled and lock held
>   * have a longer timeout
>   * call schedule while spinning to provide some responsivness

It doesn't call schedule() - it calls yield().

yield() is pretty notoriously badly behaved in the presence of lots of
runnable tasks and there's been a general move to eradicate its
in-kernel callsites.

An alternative would be nice.

