Return-Path: <linux-kernel-owner+w=401wt.eu-S933565AbXK2VJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933565AbXK2VJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 16:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756222AbXK2VJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 16:09:35 -0500
Received: from mx1.suse.de ([195.135.220.2]:34974 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102AbXK2VJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 16:09:34 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: tvrtko.ursulin@sophos.com, Al Viro <viro@ftp.linux.org.uk>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Valdis.Kletnieks@vt.edu
Subject: Re: Out of tree module using LSM
From: Andi Kleen <andi@firstfloor.org>
References: <20071128183040.GW8181@ftp.linux.org.uk>
	<OF699E23DA.E36E712D-ON802573A2.00591FA8-802573A2.005A44A2@sophos.com>
	<20071129173601.34273083@the-village.bc.nu>
Date: Thu, 29 Nov 2007 22:09:33 +0100
In-Reply-To: <20071129173601.34273083@the-village.bc.nu> (Alan Cox's message of "Thu\, 29 Nov 2007 17\:36\:01 +0000")
Message-ID: <p73myswyd0y.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> If I want I can have 16 threads executing code in a shared object being
> written to by ten other programs at once and shared over a network while
> we are at it. Its probably not a good idea but I can do it if I have
> reason to.

Actually the kernel prevents writing to files which are executed currently
and you can also not execute what is currently open for writing.
That is what VM_DENYWRITE is good for.

Does not work for shared libraries though -- you cannot set VM_DENYWRITE
in user mmap aka ld.so Man page says

  MAP_DENYWRITE
              This flag is ignored.  (Long ago, it signalled that attempts to write to the underlying file should fail
              with ETXTBUSY.  But this was a source of denial-of-service attacks.)

-Andi
