Return-Path: <linux-kernel-owner+w=401wt.eu-S1761948AbXJOKv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761948AbXJOKv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 06:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758263AbXJOKvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 06:51:19 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:25394 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758323AbXJOKvS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 06:51:18 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: Re: [RESEND 2][PATCH 0/4] Virtual Machine Time Accounting
Date: Mon, 15 Oct 2007 12:51:12 +0200
User-Agent: KMail/1.9.7
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
References: <46E550D7.6090805@bull.net>
In-Reply-To: <46E550D7.6090805@bull.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710151251.12981.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 10. September 2007 schrieb Laurent Vivier:
> The aim of these four patches is to introduce Virtual Machine time accounting.

I would move this line
       if (p->flags & PF_VCPU) {
               account_guest_time(p, cputime);
------>                p->flags &= ~PF_VCPU;  <---------
               return;
       }
into kvm_guest_exit. Otherwise a guest that is running very long in 
guest context would only get the first tick accounted as guest time, no?

Besides that, this looks good and should work for kvm on s390 as well. 
Thanks Laurent.

Christian


