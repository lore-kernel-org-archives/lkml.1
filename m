Return-Path: <linux-kernel-owner+w=401wt.eu-S1759393AbYAKLMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393AbYAKLMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 06:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756998AbYAKLMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 06:12:10 -0500
Received: from ns.suse.de ([195.135.220.2]:44724 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756760AbYAKLMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 06:12:08 -0500
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: linux-kernel@vger.kernel.org, mpm@selenic.com
Subject: Re: Query on lock protection in random number driver
From: Andi Kleen <andi@firstfloor.org>
References: <1200049691.3844.44.camel@nikanth-laptop.blr.novell.com>
Date: Fri, 11 Jan 2008 12:12:06 +0100
In-Reply-To: <1200049691.3844.44.camel@nikanth-laptop.blr.novell.com> (Nikanth Karthikesan's message of "Fri\, 11 Jan 2008 16\:38\:11 +0530")
Message-ID: <p73fxx4mxa1.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nikanth Karthikesan <knikanth@suse.de> writes:
>
> Also the globals random_read_wakeup_thresh and
> random_write_wakeup_thresh are not at all protected by any locks! Why
> locks are not needed for these?

Reading variables sizeof <= native word size (32bit or 64bit depending
on architecture) is atomic by itself. This is not necessarily
guaranteed in ISO-C or POSIX threads, but Linux can assume that.

-Andi
