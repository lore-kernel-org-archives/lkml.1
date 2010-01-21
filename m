Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019Ab0AUQ6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab0AUQ6x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 11:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887Ab0AUQ6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 11:58:52 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:49736 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862Ab0AUQ6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 11:58:52 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 21 Jan 2010 08:58:50 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: "Michael S. Tsirkin" <mst@redhat.com>
cc: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 1/3] eventfd: allow atomic read and waitqueue remove
In-Reply-To: <20100121162648.GA16458@redhat.com>
Message-ID: <alpine.DEB.2.00.1001210857310.8548@makko.or.mcafeemobile.com>
References: <20100121162648.GA16458@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jan 2010, Michael S. Tsirkin wrote:

> This is a backport of commit: 03db343a6320f780937078433fa7d8da955e6fce
> modified in a way that introduces some code duplication on the one hand,
> but reduces the risk of regressing existing eventfd users on the other
> hand.
> 
> KVM needs a wait to atomically remove themselves from the eventfd
> ->poll() wait queue head, in order to handle correctly their IRQfd
> deassign operation.
> 
> This patch introduces such API, plus a way to read an eventfd from its
> context.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> Avi, Davidel, how about only including the following part for -stable
> then?  Reason is, I still would like to be able to use irqfd there, and
> getting spurious interrupts 100% of times unmask is done isn't a very
> good idea IMO ...

It's the same thing. Unless there are *real* problems in KVM due to the 
spurious ints, I still think this is .33 material.


- Davide


