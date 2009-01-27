Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbZA0SRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbZA0SRG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 13:17:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbZA0SQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 13:16:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:55465 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbZA0SQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 13:16:54 -0500
Date: 27 Jan 2009 19:15:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org
Cc: apw@shadowen.org
Cc: kosaki.motohiro@jp.fujitsu.com
Cc: kyle@infradead.org
Cc: linux-kernel@vger.kernel.org
Message-ID: <Aufg85sZjFB@christoph>
In-Reply-To: <alpine.LFD.2.00.0901270741490.3123@localhost.localdomain>
Subject: Re: [PATCH] make checkpatch warn about access to current->comm
User-Agent: OpenXP/4.10.7369 (Linux) (i386)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1+YJqdBwDsE7OcwvB1soW2Dok7v9sF2Vs9D5kL
 9imCZYl6A1nRxNVWWyGQRQ+0ZbryrTDzPpWHVTWfoU5IM5P5Mk
 LWntlD3PTSiVWTa8wrFbrYXF4paoSaVD1i4xUzXqdc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 Jan 09 at 07:45, Linus Torvalds wrote:
> On Tue, 27 Jan 2009, Kyle McMartin wrote:
>>
>> Suggest using the get_task_comm accessor versus direct access to
>> current->comm.

> I think "current->comm" is fine, and not racy.
>
> It only gets racy when you ask for the name of _another_ task.
>
> And quite frankly, I don't think anybody but /proc does that anyway. I
> think this whole "get_task_comm()" thing is overrated. Most people are
> better off doing just "current->comm".

This issue only came up because for someone like me it's not obvious at  
all that using "current->comm" is safe and the comment in sched.h  
explicitly points out that task_struct.comm should be accessed with  
[gs]et_task_comm.

Christoph
