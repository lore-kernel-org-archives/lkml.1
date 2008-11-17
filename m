Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724AbYKQGwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbYKQGwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 01:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbYKQGwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 01:52:32 -0500
Received: from ms1.nttdata.co.jp ([163.135.193.232]:57699 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbYKQGwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 01:52:32 -0500
Message-ID: <492114A6.3020905@nttdata.co.jp>
Date: Mon, 17 Nov 2008 15:52:22 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.8.1.17) Gecko/20080914 Thunderbird/2.0.0.17 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: haradats@nttdata.co.jp, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp
Subject: Re: [TOMOYO #12 (2.6.28-rc2-mm1) 04/11] Introduce d_realpath().
References: <20081104060847.086543472@nttdata.co.jp>	<20081104060948.233911964@nttdata.co.jp> <20081105151212.9c6053eb.akpm@linux-foundation.org>
In-Reply-To: <20081105151212.9c6053eb.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Nov 2008 06:52:25.0603 (UTC) FILETIME=[0C97DD30:01C94881]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 04 Nov 2008 15:08:51 +0900
> Kentaro Takeda <takedakn@nttdata.co.jp> wrote:
> 
>> +		/*
>> +		 * Exception: Use /proc/self/ rather than /proc/\$/
>> +		 * for current process.
>> +		 */
>> +		name = dentry->d_name.name;
>> +		name_len = dentry->d_name.len;
>> +		if (IS_ROOT(parent) &&
>> +		    parent->d_sb->s_magic == PROC_SUPER_MAGIC &&
>> +		    !strict_strtoul(name, 10, &pid)) {
> 
> Well that looks like rather a hack.
> 
> It would still be a hack, but a better implementation might be to save
> the procfs superblock's address in a global then do
> 
> 
> #ifdef CONFIG_PROCFS
> static inline bool is_procfs_sb(struct super_block *sb)
> {
> 	return sb == saved_procfs_sb;
> }
> #else
> static inline bool is_procfs_sb(struct super_block *sb)
> {
> 	return false;
> }
> #endif
It seems to me that the procfs superblock's address is not a single value
because proc_get_sb() in fs/proc/root.c could be called for multiple times.
Thus, I'd like to continue using "parent->d_sb->s_magic == PROC_SUPER_MAGIC"
rather than "is_procfs_sb(parent->d_sb)".

I think I've replied to most of your comments.
Is there anything we can do before reposting TOMOYO #13 ?

Regards,


