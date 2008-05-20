Return-Path: <linux-kernel-owner+w=401wt.eu-S933434AbYETPQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933434AbYETPQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932298AbYETPQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:16:13 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:27670 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297AbYETPQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:16:13 -0400
To: Avi Kivity <avi@qumranet.com>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Make LIST_POISON less deadly (v3)
From: Andi Kleen <andi@firstfloor.org>
References: <1211283565-30671-1-git-send-email-avi@qumranet.com>
Date: Tue, 20 May 2008 17:15:36 +0200
In-Reply-To: <1211283565-30671-1-git-send-email-avi@qumranet.com> (Avi Kivity's message of "Tue, 20 May 2008 14:39:25 +0300")
Message-ID: <87fxsdgg6f.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 20 May 2008 15:08:34.0209 (UTC) FILETIME=[5F4BE910:01C8BA8B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@qumranet.com> writes:
>  
> +config ILLEGAL_POINTER_VALUE
> +       hex
> +       default 0 if X86_32
> +       default 0xffffc10000000000 if X86_64

Don't make it exactly 0xffffc10000000000 but 0xffffc10000000000 + 0x1000000
or so, otherwise list_entry() users which subtract offsets would still
end up in user space and there might be actually something in there
by default.

-Andi

