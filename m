Return-Path: <linux-kernel-owner+w=401wt.eu-S1755560AbYBVJ2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbYBVJ2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 04:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbYBVJ2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 04:28:42 -0500
Received: from twin.jikos.cz ([213.151.79.26]:45489 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbYBVJ2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 04:28:40 -0500
Date: Fri, 22 Feb 2008 10:28:32 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Pioz <pioz84@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Keyboard interrupt - request_irq()
In-Reply-To: <caf255910802210804u1ca0558u8b228a075627b4a5@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802221027420.7699@twin.jikos.cz>
References: <caf255910802210804u1ca0558u8b228a075627b4a5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008, Pioz wrote:

>   I have a problem.
> I want handle the keyboard interrupt and for this purpose I have write
> this module (I have kernel 2.6.23):
[ ... ]
>         res = request_irq (1, irq_myhandler, IRQF_SHARED, "bao", dev_id);
[ ... ]
> The return value of request_irq() function is -EBUSY. Why? Is the
> default handler? How can I do to change handler with my function?
> Thanks...

The check in setup_irq() very probably triggers for you:

               /*
                 * Can't share interrupts unless both agree to and are
                 * the same type (level, edge, polarity). So both flag
                 * fields must have IRQF_SHARED set and the bits which
                 * set the trigger type must match.
                 */
                if (!((old->flags & new->flags) & IRQF_SHARED) ||
                    ((old->flags ^ new->flags) & IRQF_TRIGGER_MASK)) {
                        old_name = old->name;
                        goto mismatch;
                }

-- 
Jiri Kosina
SUSE Labs

