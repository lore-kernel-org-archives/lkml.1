Return-Path: <linux-kernel-owner+w=401wt.eu-S932782AbXCGFTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782AbXCGFTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 00:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964865AbXCGFTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 00:19:38 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34201 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932782AbXCGFTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 00:19:37 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: michael@ellerman.id.au
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 2/3] msi:  Fixup the msi enable/disable logic
References: <m1tzx7l7z2.fsf@ebiederm.dsl.xmission.com>
	<m1ps7vl7rr.fsf@ebiederm.dsl.xmission.com>
	<m1lkijl7ms.fsf_-_@ebiederm.dsl.xmission.com>
	<1172802408.518.44.camel@concordia.ozlabs.ibm.com>
Date: Tue, 06 Mar 2007 22:19:06 -0700
In-Reply-To: <1172802408.518.44.camel@concordia.ozlabs.ibm.com> (Michael
	Ellerman's message of "Fri, 02 Mar 2007 11:26:48 +0900")
Message-ID: <m1wt1td41h.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

>
> Hi Eric, comments below ..
>
>
> I get the reasoning for disabling MSI before we start writing back the
> config space, but don't we want to re-enable MSI on the way out?

We are restoring the entire msi flags register which includes the enable bit,
setting it a second time is gratuitous.

In addition if we are restoring the register when the enable bit is not set.
(because we don't have a mask bit) enabling the msi state is actually
the wrong thing to do.    But I admit that case can only happen after
the additions in my last patch.

Eric

