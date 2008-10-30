Return-Path: <linux-kernel-owner+w=401wt.eu-S1758362AbYJ3RJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362AbYJ3RJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755550AbYJ3RIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:08:49 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:46445 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755388AbYJ3RIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:08:48 -0400
Subject: Re: [Devel] Re: [PATCH 0/9] OpenVZ kernel based
	checkpointing/restart
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Louis.Rilling@kerlabs.com
Cc: Andrey Mirkin <major@openvz.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Cedric Le Goater <clg@fr.ibm.com>,
       Daniel Lezcano <dlezcano@fr.ibm.com>
In-Reply-To: <20081030114747.GL15171@hawkmoon.kerlabs.com>
References: <1220439476-16465-1-git-send-email-major@openvz.org>
	 <200810271707.13580.major@openvz.org> <4905D2AD.1070309@cs.columbia.edu>
	 <200810300902.47067.major@openvz.org>
	 <20081030114747.GL15171@hawkmoon.kerlabs.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 10:08:44 -0700
Message-Id: <1225386524.12673.284.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 12:47 +0100, Louis Rilling wrote:
> 1) this prevents userspace from doing weird things, like changing the task tree
> and let the kernel detect it and deal with the mess this creates (think about
> two threads being restarted in separate processes that do not even share their
> parents). But one can argue that userspace can change the checkpoint image as
> well, so that the kernel must check for such weird things anyway.

To me, this is one of the strongest arguments out there for doing
restart as much as possible with existing user<->kernel APIs.  Having
the kernel detect and clean up userspace's messes is not going to work.
We might as well just do things in the kernel rather than do that.

What we *should* do is leverage all of the existing APIs that we already
have instead of creating completely new code paths into which my butter
fingers can introduce new kernel bugs.

> 2) restart will be more efficient with respect to shared objects.

Can you quantify this?  Which objects?  How much more efficient?

-- Dave

