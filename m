Return-Path: <linux-kernel-owner+w=401wt.eu-S1758803AbZIPR14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803AbZIPR14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 13:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758776AbZIPR1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 13:27:54 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:63491 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753929AbZIPR1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 13:27:53 -0400
Date: Wed, 16 Sep 2009 13:27:43 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: David Miller <davem@davemloft.net>
cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, sam@ravnborg.org,
       geofft@ksplice.com
Subject: Re: [PATCH v2] sparc: Clean up linker script using new linker script
 macros.
In-Reply-To: <20090916.101924.186960949.davem@davemloft.net>
Message-ID: <alpine.DEB.1.10.0909161322260.2942@dr-wily.mit.edu>
References: <1253119592-19598-1-git-send-email-tabbott@ksplice.com> <1253119592-19598-2-git-send-email-tabbott@ksplice.com> <20090916.101924.186960949.davem@davemloft.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009, David Miller wrote:

> Can you do this cleanup without moving the relative locations of .data
> and .data1 sections?

Yes, if you just swap RW_DATA_SECTION and .data1 so it looks like

RW_DATA_SECTION(SMP_CACHE_BYTES, 0, THREAD_SIZE)
.data1 : {
	*(.data1)
}

instead, that would preserve their relative locations.

Currently, switching to RW_DATA_SECTION would still result in a change in 
their relative position that .data.page_aligned and .data.nosave would be 
between .data and .data1 (not sure if that is relevant on sparc). (this 
will change when <http://lkml.org/lkml/2009/9/16/396> is merged).

	-Tim Abbott


