Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbYENGsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbYENGsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 02:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbYENGsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 02:48:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751673AbYENGse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 02:48:34 -0400
Date: Tue, 13 May 2008 23:33:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: POHMELFS high performance network filesystem. Transactions,
 failover, performance.
Message-Id: <20080513233341.47edea7f.akpm@linux-foundation.org>
In-Reply-To: <20080513174523.GA1677@2ka.mipt.ru>
References: <20080513174523.GA1677@2ka.mipt.ru>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 21:45:24 +0400 Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> I'm please to announce POHMEL high performance network filesystem.

If any thread takes more than one kmap() at a time, it is deadlockable.
Because there is a finite pool of kmaps.  Everyone can end up holding
one or more kmaps, then waiting for someone else to release one.

Duplicating page_waitqueue() is bad.  Exporting it is probably bad too.
Better would be to help us work out why the core kernel infrastructure is
unsuitable, then make it suitable.
