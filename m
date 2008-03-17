Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbYCQDeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbYCQDeG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 23:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbYCQDdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 23:33:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbYCQDdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 23:33:54 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firewire: fix panic in handle_at_packet
Date: Sun, 16 Mar 2008 23:32:02 -0400
User-Agent: KMail/1.9.9
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>
References: <tkrat.098225020c179827@s5r6.in-berlin.de>
In-Reply-To: <tkrat.098225020c179827@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803162332.02407.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 March 2008 07:56:41 pm Stefan Richter wrote:
> This fixes a use-after-free bug in the handling of split transactions.
> The AT DMA handler of the request was occasionally executed after the
> AR DMA handler of the response.  The AT DMA handler then accessed an
> already freed packet.
>
> Reported by Johannes Berg <johannes@sipsolutions.net>.
> http://bugzilla.kernel.org/show_bug.cgi?id=9617
>
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

Panics hooking up to an x86 mac mini in target disk mode are gone on my end 
with this patch added, and the fix makes sense -- assuming I've got it right, 
in my head, of course. ;)

As I understand it, we'll now simply bail in handle_at_packet when we see 
packet == NULL, rather than trying to play with already freed memory, and 
cancelling an AT packet here should always be perfectly safe, because we're 
already onto the AR side of this transaction, and in most cases, the AT 
handler already fired anyway.

Signed-off-by: Jarod Wilson <jwilson@redhat.com>

-- 
Jarod Wilson
jwilson@redhat.com
