Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbYGBTDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbYGBTDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 15:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYGBTDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 15:03:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbYGBTDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 15:03:11 -0400
Date: Wed, 2 Jul 2008 20:03:06 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Julia Lawall <julia@diku.dk>
Cc: device-mapper development <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 2/6] drivers/md: remove null pointer dereference
Message-ID: <20080702190306.GG22522@agk.fab.redhat.com>
Mail-Followup-To: Julia Lawall <julia@diku.dk>,
	device-mapper development <dm-devel@redhat.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.0805121537100.3694@ask.diku.dk> <20080702105434.GF22522@agk.fab.redhat.com> <Pine.LNX.4.64.0807021351270.4854@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807021351270.4854@ask.diku.dk>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 01:51:41PM +0200, Julia Lawall wrote:
> In looking at it a little bit, it seems that ps.type is initialized in the
> function stored in the ctr field of the target_type structure and this
> function is called in the function stored in the message field of the same
> structure.  The function in the message structure seems to be only called
> from the function target_message in dm-ioctl.c, but I don't see the
> relation to an invocation of the ctr field.  Is that guaranteed to be
> invoked earlier?
 
ctr is short for constructor (perhaps we should rename these functions one day)
and it has to run first to set up the data structures which a subsequent
target_message may reference.

Alasdair
-- 
agk@redhat.com
