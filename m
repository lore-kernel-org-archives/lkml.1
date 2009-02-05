Return-Path: <linux-kernel-owner+w=401wt.eu-S1762780AbZBETrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762780AbZBETrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761453AbZBETgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:36:05 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:34810 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760333AbZBETgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:36:04 -0500
Date: Thu, 5 Feb 2009 14:30:29 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Robin Holt <holt@sgi.com>
cc: linux-mm@kvack.org, Andrea Arcangeli <andrea@qumranet.com>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [Patch] mmu_notifiers destroyed by __mmu_notifier_release()
 retain extra mm_count.
In-Reply-To: <20090205172303.GB8559@sgi.com>
Message-ID: <alpine.DEB.1.10.0902051427280.13692@qirst.com>
References: <20090205172303.GB8559@sgi.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drop of the refcount needs to occur  after the last use of
data in the mmstruct because mmdrop() may free the mmstruct.

Place it after the synchronize_rcu?
