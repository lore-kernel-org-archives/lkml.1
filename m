Return-Path: <linux-kernel-owner+w=401wt.eu-S1761416AbZBEUCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761416AbZBEUCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 15:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbZBEUCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 15:02:18 -0500
Received: from relay2.sgi.com ([192.48.179.30]:55472 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754402AbZBEUCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 15:02:16 -0500
Date: Thu, 5 Feb 2009 14:02:14 -0600
From: Robin Holt <holt@sgi.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>, linux-mm@kvack.org,
       Andrea Arcangeli <andrea@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [Patch] mmu_notifiers destroyed by __mmu_notifier_release()
	retain extra mm_count.
Message-ID: <20090205200214.GN8577@sgi.com>
References: <20090205172303.GB8559@sgi.com> <alpine.DEB.1.10.0902051427280.13692@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902051427280.13692@qirst.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 02:30:29PM -0500, Christoph Lameter wrote:
> The drop of the refcount needs to occur  after the last use of
> data in the mmstruct because mmdrop() may free the mmstruct.

Not this time.  We are being called from process termination and the
calling function is assured to hold one reference count.

We would also have to track how many callouts were made and then do
drops in a loop, but as stated above, I don't think it is needed.

Robin
