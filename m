Return-Path: <linux-kernel-owner+w=401wt.eu-S1755108AbYBLV4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbYBLV4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbYBLV4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:56:06 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48483 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751959AbYBLV4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:56:03 -0500
Date: Tue, 12 Feb 2008 13:55:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Execute tasklets in the same order they were queued
Message-Id: <20080212135558.d22a843a.akpm@linux-foundation.org>
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

kernel/softirq.c: In function 'takeover_tasklets':
kernel/softirq.c:597: error: 'struct tasklet_head' has no member named 'next'
kernel/softirq.c:603: error: 'struct tasklet_head' has no member named 'next'
kernel/softirq.c:588: warning: unused variable 'i'
