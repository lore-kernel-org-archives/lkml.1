Return-Path: <linux-kernel-owner+w=401wt.eu-S1753052AbYJBExg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbYJBExg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 00:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbYJBEx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 00:53:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811AbYJBEx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 00:53:26 -0400
Date: Wed, 1 Oct 2008 21:52:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Improve buffered streaming write ordering
Message-Id: <20081001215239.ee2ae63f.akpm@linux-foundation.org>
In-Reply-To: <1222886451.9158.34.camel@think.oraclecorp.com>
References: <1222886451.9158.34.camel@think.oraclecorp.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Oct 2008 14:40:51 -0400 Chris Mason <chris.mason@oracle.com> wrote:

> The patch below changes write_cache_pages to only use writeback_index
> when current_is_pdflush().  The basic idea is that pdflush is the only
> one who has concurrency control against the bdi, so it is the only one
> who can safely use and update writeback_index.

Another approach would be to only update mapping->writeback_index if
nobody else altered it meanwhile.

That being said, I don't really see why we get lots of seekiness when
two threads start their writing the file from the same offset.
