Return-Path: <linux-kernel-owner+w=401wt.eu-S1760753AbXJMGET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760753AbXJMGET (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 02:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbXJMGEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 02:04:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44020 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbXJMGEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 02:04:08 -0400
Date: Sat, 13 Oct 2007 07:04:00 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Version 6 (2.6.23) Smack: Simplified Mandatory Access Control Kernel
Message-ID: <20071013060400.GD8181@ftp.linux.org.uk>
References: <4710511D.9000709@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4710511D.9000709@schaufler-ca.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 10:01:17PM -0700, Casey Schaufler wrote:

What do you need smk_sb for?  Looks like dead weight...

smk_read_load(): obvious seq_file candidate.
smk_read_cipso(): ditto.

What protects smk_cipso_written?  BTW, its use on the read side is an
atrocity...

smk_write_doi() - WTF would NUL-terminate temp[]?  You run sscanf on
it...
smk_write_direct() - ditto
smk_write_ambient() - ditto
smk_read_ambient() - who said that you won't get write between strlen()
and simple_read_from_buffer()?

smk_import_entry():
> +	for (skp = smack_known; skp != NULL; skp = skp->smk_next)
> +		if (skp->smk_known == smack)
> +			break;
Really?  With smack[] being an auto array?

That's from quick look through the read/write in there; I hadn't really
looked into parsers or deeper into the guts.
