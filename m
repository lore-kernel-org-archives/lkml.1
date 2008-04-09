Return-Path: <linux-kernel-owner+w=401wt.eu-S1757865AbYDITJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbYDITJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 15:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757680AbYDITI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 15:08:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757654AbYDITI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 15:08:58 -0400
Date: Wed, 9 Apr 2008 12:08:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: linux-kernel@vger.kernel.org, zach.brown@oracle.com,
       jroberson@chesapeake.net
Subject: Re: [patch] eventfd/kaio integration fix
Message-Id: <20080409120812.cad8f173.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0804091138050.7000@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0804091138050.7000@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Apr 2008 11:45:47 -0700 (PDT)
Davide Libenzi <davidel@xmailserver.org> wrote:

> Jeff Roberson discovered a race when using kaio eventfd based 
> notifications. This patch fixes the race by moving the notification inside 
> the spinlocked section of kaio.

Missing information.

What are the consequences of this race, when it occurs?

> The operation is safe since eventfd 
> spinlock and kaio one are unrelated.

Yes, it's safe from that perspective.

However with this patch applied, we will no longer run eventfd_signal() if
kiocbIsCancelled(iocb).  Convincing is needed, please?
