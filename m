Return-Path: <linux-kernel-owner+w=401wt.eu-S1758466AbYHOO5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466AbYHOO5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 10:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbYHOO5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 10:57:16 -0400
Received: from vena.lwn.net ([206.168.112.25]:32978 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041AbYHOO5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 10:57:16 -0400
Date: Fri, 15 Aug 2008 08:57:14 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: djwong@us.ibm.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] msr: Fix NULL pointer deref due to msr_open on
 nonexistent CPUs
Message-ID: <20080815085714.18eb1c8e@bike.lwn.net>
In-Reply-To: <20080814224333.GG28450@tree.beaverton.ibm.com>
References: <20080814224333.GG28450@tree.beaverton.ibm.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008 15:43:33 -0700
"Darrick J. Wong" <djwong@us.ibm.com> wrote:

> msr_open tests for someone trying to open a device for a nonexistent
> CPU. However, the function always returns 0, not ret like it should,
> hence userspace can BUG the kernel trivially.  This bug was
> introduced by the cdev lock_kernel pushdown patch last May.

> -	return 0;
> +	return ret;

Oops, that was pretty silly.  Apologies for the screwup.

jon
