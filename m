Return-Path: <linux-kernel-owner+w=401wt.eu-S935301AbZJOT1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935301AbZJOT1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 15:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933560AbZJOT1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 15:27:08 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:57065 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933584AbZJOT1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 15:27:06 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH] hvc_console: returning 0 from put_chars is not an error
Date: Thu, 15 Oct 2009 21:26:27 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc4-self-00094-g80f5069-dirty; KDE/4.3.1; i686; ; )
Cc: Timur Tabi <timur@freescale.com>, linuxppc-dev@ozlabs.org,
       brueckner@linux.vnet.ibm.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1255557226-4403-1-git-send-email-timur@freescale.com> <200910152041.26646.borntraeger@de.ibm.com> <4AD770A9.6070509@freescale.com>
In-Reply-To: <4AD770A9.6070509@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200910152126.28024.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 15 Oktober 2009 20:57:45 schrieb Scott Wood:
> Doing it in the backend requires the backend to know whether it's being
> called for printk or for user I/O.  In the latter case, we don't want to
> spin, but rather wait for an IRQ (or poll with a timer if there's no IRQ).

Right. Now you have me convinced that we really should have some logic in 
hvc_console because, its the only place that knows if it came from printk or 
user.

About the backends, there are some that spin until the text is delivered (e.g. 
virtio) , others can drop (e.g. iucv is a connection oriented protocol and it 
will (and has to) drop if there is no connection). 
