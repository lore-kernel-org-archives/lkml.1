Return-Path: <linux-kernel-owner+w=401wt.eu-S1758603AbZASDIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603AbZASDIB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 22:08:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757682AbZASDHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 22:07:49 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:52485 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757667AbZASDHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 22:07:48 -0500
Date: Sun, 18 Jan 2009 20:07:32 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: "Gao, Yunpeng" <yunpeng.gao@intel.com>
Cc: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: your mail
Message-ID: <20090119030731.GA28670@parisc-linux.org>
References: <38D9F46DFF92C54980D2F2C1E8EE31301FC5E7FB@pdsmsx503.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38D9F46DFF92C54980D2F2C1E8EE31301FC5E7FB@pdsmsx503.ccr.corp.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 10:54:02AM +0800, Gao, Yunpeng wrote:
> I have to use 64bit variable in my 2.6.27 kernel NAND driver as below:
> ---------------------------------------------------------------------------
> u64 NAND_capacity;
> unsigned int block_num, block_size;
> ...
> block_num = NAND_capacity / block_size;
> ---------------------------------------------------------------------------
> but it failed when compiling and reports 'undefined reference to `__udivdi3'.

Presumably block_size is a power of two, so you can do:

	block_num = NAND_capacity >> block_shift;

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
