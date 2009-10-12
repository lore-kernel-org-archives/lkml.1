Return-Path: <linux-kernel-owner+w=401wt.eu-S1757825AbZJLSnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825AbZJLSnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:43:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757666AbZJLSnC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:43:02 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38352 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757613AbZJLSnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:43:01 -0400
Date: Mon, 12 Oct 2009 20:42:24 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bernhard Walle <bernhard@bwalle.de>, Andi Kleen <andi@firstfloor.org>,
       akpm@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] Always print panic message on current console
Message-ID: <20091012184224.GB20412@basil.fritz.box>
References: <1255207870-24496-1-git-send-email-bernhard@bwalle.de> <1255207870-24496-6-git-send-email-bernhard@bwalle.de> <87d44sh5uj.fsf@basil.nowhere.org> <4AD37478.2070204@bwalle.de> <20091012113055.13d3b7e3@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012113055.13d3b7e3@jbarnes-g45>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It's called in the panic notifier atm.  Yeah sounds like kexec vs
> notifiers should be reordered a bit (or the current panic notifier
> should be split into notify and "yes we actually failed to do anything"
> cases).

I think it needs oops_begin() move over to a generalized panic_begin()
which is used everywhere there are multiple line panics.

oops_begin could do all these things, possibly with a new notifier.

This could also solve a couple of other open issues, like
currently we can have parallel panics deadlocking so doing proper
locking.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
