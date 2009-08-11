Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbZHKSSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbZHKSSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbZHKSSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:18:43 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:63118 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbZHKSSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:18:43 -0400
Message-ID: <4A81B646.5060301@colorfullife.com>
Date: Tue, 11 Aug 2009 20:19:50 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: npiggin@suse.de
CC: Andrew Morton <akpm@linux-foundation.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/4] ipc: sem optimise simple operations
References: <20090811110902.255877673@suse.de> <20090811111607.310739140@suse.de>
In-Reply-To: <20090811111607.310739140@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2009 01:09 PM, npiggin@suse.de wrote:
> Index: linux-2.6/include/linux/sem.h
> ===================================================================
> --- linux-2.6.orig/include/linux/sem.h
> +++ linux-2.6/include/linux/sem.h
> @@ -86,6 +86,8 @@ struct task_struct;
>   struct sem {
>   	int	semval;		/* current value */
>   	int	sempid;		/* pid of last operation */
> +	struct list_head	negv_pending;
> +	struct list_head	zero_pending;
>   };
>    
struct sem is increased from 8 to 24 bytes.
Is that still ok? Are there any apps that use really lots of semaphores 
(i.e.: far more than processes in the system?)

Postgres uses lots of small semaphore sets (each with 17 entries), I 
never had access to other apps.
