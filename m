Return-Path: <linux-kernel-owner+w=401wt.eu-S1757097AbZC2OUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097AbZC2OUn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 10:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZC2OUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 10:20:32 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:40553 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbZC2OUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 10:20:31 -0400
Date: Sun, 29 Mar 2009 16:20:24 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Rik van Riel <riel@redhat.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       frankeh@watson.ibm.com, akpm@osdl.org, nickpiggin@yahoo.com.au,
       hugh@veritas.com
Subject: Re: [patch 0/6] Guest page hinting version 7.
Message-ID: <20090329162024.687196ab@skybase>
In-Reply-To: <49CD69EB.6000000@redhat.com>
References: <20090327150905.819861420@de.ibm.com>
	<1238195024.8286.562.camel@nimitz>
	<49CD69EB.6000000@redhat.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009 20:06:03 -0400
Rik van Riel <riel@redhat.com> wrote:

> Dave Hansen wrote:
> > On Fri, 2009-03-27 at 16:09 +0100, Martin Schwidefsky wrote:
> >> If the host picks one of the
> >> pages the guest can recreate, the host can throw it away instead of writing
> >> it to the paging device. Simple and elegant.
> > 
> > Heh, simple and elegant for the hypervisor.  But I'm not sure I'm going
> > to call *anything* that requires a new CPU instruction elegant. ;)
> 
> I am convinced that it could be done with a guest-writable
> "bitmap", with 2 bits per page.  That would make this scheme
> useful for KVM, too.

This was our initial approach before we came up with the milli-code
instruction. The reason we did not use a bitmap was to prevent the
guest to change the host state (4 guest states U/S/V/P and 3 host
states r/p/z). With the full set of states you'd need 4 bits. And the
hosts need to have a "master" copy of the host bits, one the guest
cannot change, otherwise you get into trouble.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

