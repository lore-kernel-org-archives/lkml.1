Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbYB2LoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbYB2LoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 06:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbYB2Ln7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 06:43:59 -0500
Received: from twin.jikos.cz ([213.151.79.26]:35524 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbYB2Ln6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 06:43:58 -0500
Date: Fri, 29 Feb 2008 12:43:19 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Jiri Olsa <olsajiri@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] soft lockup detected with ipcs
In-Reply-To: <47C7E280.4010805@gmail.com>
Message-ID: <Pine.LNX.4.64.0802291241080.7699@twin.jikos.cz>
References: <47C7E280.4010805@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008, Jiri Olsa wrote:

> when I run 'ipcs' my system freeze up immediatelly. I was able to get 
> kernel BUG message once, I think it is not printed out all the time it 
> freeze.
> I tried on 2.6.24, 2.6.20 and 2.6.18.
> I attached screenshot from 2.6.18 freeze and config.

Could you please turn all the lock debugging options in your .config on 
(most importantly CONFIG_PROVE_LOCKING, and all the other lock debugging 
options might come handy too) and try again, to see if we get any debug 
error messages? I'd guess that someone is holding mqueue_inode_info->lock 
for too long or there is some AB-BA deadlock on it, which lockdep and 
friends might be able to diagnose.

-- 
Jiri Kosina
SUSE Labs

