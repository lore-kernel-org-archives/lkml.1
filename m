Return-Path: <linux-kernel-owner+w=401wt.eu-S1758640AbYG1PyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640AbYG1PyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbYG1PyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:54:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53858 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754759AbYG1Px7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:53:59 -0400
Date: Mon, 28 Jul 2008 08:50:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Set clear flag in copy_from_user/copy_to_user
In-Reply-To: <m3ej5edrde.fsf@gravicappa.englab.brq.redhat.com>
Message-ID: <alpine.LFD.1.10.0807280848520.3486@nehalem.linux-foundation.org>
References: <m3ej5edrde.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 28 Jul 2008, Vitaly Mayatskikh wrote:
>
> Only copy_to_user should clear the rest of uncopied area.

Copy *from* user should clear the kernel result buffer tail. Copying *to* 
user should do no such thing, and cannot do it anyway, since if we get a 
fault, it's going to be in that tail that caused a fault to begin with.

		Linus
