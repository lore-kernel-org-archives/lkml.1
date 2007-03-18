Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbXCROwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbXCROwP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 10:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbXCROwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 10:52:15 -0400
Received: from mx1.suse.de ([195.135.220.2]:42664 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781AbXCROwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 10:52:15 -0400
To: "Ying Chu" <xjtuychu@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sysenter cause a segmentation fault.
References: <b965e8580703180108t6bc50b0eg895c5464463ab09@mail.gmail.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 18 Mar 2007 16:51:21 +0100
In-Reply-To: <b965e8580703180108t6bc50b0eg895c5464463ab09@mail.gmail.com>
Message-ID: <p733b427dom.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Ying Chu" <xjtuychu@gmail.com> writes:

> A simple code running on PIII 800,kernel 2.6.20 with SEP enabled
> causes  a  segmentation fault.

SYSENTER has a hardcoded return address, that is why you cannot be used
anywhere but in the vsyscall trampoline.  In addition it doesn't work
on x86-64 for 32bit processes for AMD. The only system call method
supported without the vDSO is int 0x80. Better you just use the vDSO.

> More, when i enabled Kdb and set "bp sysenter_entry",it went with a
> catastrophic error errupted.

The stack and some other kernel state are not set up yet at this point.

-Andi
