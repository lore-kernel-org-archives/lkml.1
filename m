Return-Path: <linux-kernel-owner+w=401wt.eu-S1753882AbYFIPXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882AbYFIPXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 11:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbYFIPXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 11:23:36 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48691 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759343AbYFIPXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 11:23:35 -0400
Subject: Re: [PATCH 03/15] x86: remove early_gdt_descr reference
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Glauber Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu, hugh@veritas.com
In-Reply-To: <1213021018-14159-4-git-send-email-gcosta@redhat.com>
References: <1213021018-14159-1-git-send-email-gcosta@redhat.com>
	 <1213021018-14159-2-git-send-email-gcosta@redhat.com>
	 <1213021018-14159-3-git-send-email-gcosta@redhat.com>
	 <1213021018-14159-4-git-send-email-gcosta@redhat.com>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 10:23:02 -0500
Message-Id: <1213024983.3508.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-09 at 11:16 -0300, Glauber Costa wrote:
> since we use switch_to_new_gdt, there is no point
> in assigning early_gdt_descr except for the first
> assignment, which is done manually.

What makes you think you can do this?  If you don't update the early
boot gdt, they all end up using the Boot CPU one.  The problem with this
is that there's a time from start_secondary to switch_to_new_gdt where
the per cpu selector (%fs) and the pda selector (%gs) are those of the
boot CPU.   The former isn't a problem but the CPU number is in the
latter, and it's used in that path before we get to the initialisation.

James


