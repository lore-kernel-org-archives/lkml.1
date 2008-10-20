Return-Path: <linux-kernel-owner+w=401wt.eu-S1753860AbYJTNsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbYJTNsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 09:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbYJTNsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 09:48:39 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:56778 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbYJTNsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 09:48:38 -0400
Message-ID: <48FC8C30.6040409@fr.ibm.com>
Date: Mon, 20 Oct 2008 15:48:32 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Daniel Lezcano <dlezcano@fr.ibm.com>
CC: Louis.Rilling@kerlabs.com, Dave Hansen <dave@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, Andrey Mirkin <major@openvz.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] OpenVZ kernel based checkpointing/restart
References: <1220439476-16465-1-git-send-email-major@openvz.org> <1224286383.1848.65.camel@nimitz> <20081020111002.GQ15171@hawkmoon.kerlabs.com> <48FC86B2.8000606@fr.ibm.com>
In-Reply-To: <48FC86B2.8000606@fr.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I'm afraid that we are forgetting to take the best from both
>> approaches...
> 
> I agree with Louis.
> 
> I played with Oren's patchset and tryed to port it on x86_64. I was able
> to sys_checkpoint/sys_restart but if you remove the restoring of the
> general registers, the restart still works. I am not an expert on asm,
> but my hypothesis is when we call sys_checkpoint the registers are saved
> on the stack by the syscall and when we restore the memory of the
> process, we restore the stack and the stacked registers are restored
> when exiting the sys_restart. That make me feel there is an important
> gap between external checkpoint and internal checkpoint.
> 
> Dmitry's patchset is nice too, but IMO, it goes too far from what we

I think you are talking about Andrey.

C.

> decided to do at the container mini-summit. I think there are a lot of
> design questions to be solved before going further.
> 
> IMHO we should look at Dmitry patchset and merge the external checkpoint
> code to Oren's patchset in order to checkpoint *one* process and have
> the process to restart itself. At this point, we can begin to talk about
> the restart itself, shall we have the kernel to fork the processes to be
> restarted ? shall we fork from userspace and implement some mechanism to
> have each processes to restart themselves ? etc...
