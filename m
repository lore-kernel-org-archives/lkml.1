Return-Path: <linux-kernel-owner+w=401wt.eu-S1752401AbXFDBV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbXFDBV3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 21:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbXFDBVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 21:21:23 -0400
Received: from ns1.suse.de ([195.135.220.2]:46879 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbXFDBVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 21:21:22 -0400
From: Neil Brown <neilb@suse.de>
To: "Aaron Wiebe" <epiphani@gmail.com>
Date: Mon, 4 Jun 2007 11:20:55 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18019.26871.317501.633363@notabene.brown>
Cc: linux-kernel@vger.kernel.org, "John Stoffel" <john@stoffel.org>
Subject: Re: slow open() calls and o_nonblock
In-Reply-To: message from Aaron Wiebe on Sunday June 3
References: <e7ca40f70706031152q4e9630aq3c29623bd56fe0e5@mail.gmail.com>
	<18019.21781.470399.393340@stoffel.org>
	<e7ca40f70706031805h56da4c3ag2dd0e902430785cc@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday June 3, epiphani@gmail.com wrote:
> 
> You can certainly open the file, but not block on the call to do it.
> What confuses me is why the kernel would "block" for 415ms on an open
> call.  Thats an eternity to suspend a process that has to distribute
> data such as this.

Have you tried the "nocto" mount option for your NFS filesystems.

The cache-coherency rules of NFS require the client to check with the
server at each open.  If you are the sole client on this filesystem,
then you don't need the same cache-coherency, and "nocto" will tell
the NFS client not to both checking with the server in information is
available in cache.

This should speed up the time for open considerably.

NeilBrown
