Return-Path: <linux-kernel-owner+w=401wt.eu-S932131AbZHUNGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131AbZHUNGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 09:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755583AbZHUNGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 09:06:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755480AbZHUNGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 09:06:09 -0400
Date: Fri, 21 Aug 2009 15:09:22 +0200
From: Michal Schmidt <mschmidt@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Mark McLoughlin <markmc@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: DomU crashes during xenfb initialization
Message-ID: <20090821150922.72e12d9a@leela>
In-Reply-To: <20090821124059.17ab93fa@leela>
References: <20090821124059.17ab93fa@leela>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Fri, 21 Aug 2009 12:40:59 +0200 Michal Schmidt napsal:
> So it crashes during Xen framebuffer initialization. And indeed,
> disabling CONFIG_XEN_FBDEV_FRONTEND helps, the kernel then boots fine.
> 
> I git-bisected it and found that the bug was introduced by this
> commit: commit ced40d0f3e8833bb8d7d8e2cbfac7da0bf7008c4
> Author: Jeremy Fitzhardinge <jeremy@goop.org>
> Date:   Fri Feb 6 14:09:44 2009 -0800
> 
>     xen: pack all irq-related info together

It's not this commit's fault. It just uncovered a latent bug.
info->irq is -1 in xenfb_send_event(), so it calls
notify_remote_via_irq(-1) which then dereferences out-of-array memory.

Michal
