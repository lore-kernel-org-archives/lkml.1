Return-Path: <linux-kernel-owner+w=401wt.eu-S1752429AbXLYXsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbXLYXsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 18:48:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbXLYXro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 18:47:44 -0500
Received: from ozlabs.org ([203.10.76.45]:42691 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbXLYXrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 18:47:43 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH 13/16] per-vcpu lguest task management
Date: Wed, 26 Dec 2007 10:47:38 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: lguest@ozlabs.org, glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rostedt@goodmis.org
References: <11981576363806-git-send-email-gcosta@redhat.com> <11981576972655-git-send-email-gcosta@redhat.com> <11981577021091-git-send-email-gcosta@redhat.com>
In-Reply-To: <11981577021091-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712261047.39247.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 December 2007 00:33:53 Glauber de Oliveira Costa wrote:
> @@ -114,6 +116,19 @@ static int vcpu_start(struct lguest_vcpu *vcpu, int
> vcpu_id, * address. */
>  	lguest_arch_setup_regs(vcpu, start_ip);
>
> +	/* Initialize the queue for the waker to wait on */
> +	init_waitqueue_head(&vcpu->break_wq);
> +
> +	/* We keep a pointer to the Launcher task (ie. current task) for when
> +	 * other Guests want to wake this one (inter-Guest I/O). */
> +	vcpu->tsk = current;
> +
> +	/* We need to keep a pointer to the Launcher's memory map, because if
> +	 * the Launcher dies we need to clean it up.  If we don't keep a
> +	 * reference, it is destroyed before close() is called. */
> +	vcpu->mm = get_task_mm(vcpu->tsk);
> +
> +

Nitpick: extra line?

Cheers,
Rusty.
