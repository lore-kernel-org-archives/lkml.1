Return-Path: <linux-kernel-owner+w=401wt.eu-S1759693AbYBKWum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759693AbYBKWum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 17:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325AbYBKWu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 17:50:28 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40033 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753330AbYBKWu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 17:50:27 -0500
Date: Mon, 11 Feb 2008 14:49:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Execute tasklets in the same order they were queued
Message-Id: <20080211144927.55920e56.akpm@linux-foundation.org>
In-Reply-To: <20080211222813.GA14316@lixom.net>
References: <20080211222813.GA14316@lixom.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008 16:28:13 -0600
Olof Johansson <olof@lixom.net> wrote:

> I noticed this when looking at an openswan issue. Openswan (ab?)uses
> the tasklet API to defer processing of packets in some situations,
> with one packet per tasklet_action(). I started noticing sequences of
> reverse-ordered sequence numbers coming over the wire, since new tasklets
> are always queued at the head of the list but processed sequentially.
> 
> Convert it to instead append new entries to the tail of the list. As an
> extra bonus, the splicing code in takeover_tasklets() no longer has to
> iterate over the list.
> 

hm, I'd have thought that this would already have caused problems in
networking.  And perhaps this change might have effects on networking too?

Probably it won't have _much_ effect on networking because networking
probably isn't queueing one tasklet per packet(!) but perhaps with bonded
channels or something like that?

