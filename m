Return-Path: <linux-kernel-owner+w=401wt.eu-S1752057AbXDKFTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbXDKFTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 01:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbXDKFTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 01:19:04 -0400
Received: from smtp.osdl.org ([65.172.181.24]:59666 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057AbXDKFTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 01:19:01 -0400
Date: Tue, 10 Apr 2007 22:18:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kenchen@google.com (Ken Chen)
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] convert aio event reap to use atomic-op instead of
 spin_lock
Message-Id: <20070410221849.dcec1ce3.akpm@linux-foundation.org>
In-Reply-To: <20070410235353.325A7346F64@localhost>
References: <20070410235353.325A7346F64@localhost>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2007 16:53:53 -0700 (PDT) kenchen@google.com (Ken Chen) wrote:

> +	} while (head != cmpxchg(&ring->head, head, head + 1));

A hasty grep indicates that only 14 out of 23 architectures implement
cmpxchg().
