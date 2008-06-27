Return-Path: <linux-kernel-owner+w=401wt.eu-S1756644AbYF0NMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644AbYF0NMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 09:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbYF0NL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 09:11:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbYF0NL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 09:11:56 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org,
       Benjamin LaHaise <bcrl@kvack.org>, Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] aio: aio_complete() will never be called in interrupt context
References: <200806260930.59836.knikanth@suse.de>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 27 Jun 2008 09:11:03 -0400
In-Reply-To: <200806260930.59836.knikanth@suse.de> (Nikanth Karthikesan's
	message of "Thu, 26 Jun 2008 09:30:59 +0530")
Message-ID: <x49tzfft448.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nikanth Karthikesan <knikanth@suse.de> writes:

> aio_complete() is never called from interrupt context. It is called from user 
> context or worker threads. Remove disabling interrupts and for kmap_atomic use 
> KM_USER slots instead of KM_IRQ slots.

Actually, it can be called from softirq context.  See fs/directio.c.

Cheers,

Jeff
