Return-Path: <linux-kernel-owner+w=401wt.eu-S1753108AbXJ1VWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbXJ1VWD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 17:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbXJ1VVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 17:21:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35257 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbXJ1VVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 17:21:54 -0400
Date: Sun, 28 Oct 2007 22:21:50 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix x86_64 TIF_SYSCALL_TRACE race in entry.S
Message-ID: <20071028212150.GA20321@one.firstfloor.org>
References: <20071026193738.GA1591@Krystal> <20071027180837.GA18134@Krystal> <p73sl3wnzty.fsf@bingen.suse.de> <20071028211527.GA9129@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071028211527.GA9129@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Setting the thread flag being an atomic operation, I would expect
> setting/clearing it asynchronously from another thread to be a valid

It could be a very short stop. Also do you start kernel tracing that often?

> Here is a modified version where I add my test only in the path where we
> know that we have work to do, therefore removing the supplementary test
> from the performance critical path. Would it be more acceptable ?

It's better, but stopping would be even better. I wouldn't
be surprised if there are other problems with async thread flags changing.
 
Also I object to you calling this a bug. It's a new feature.

-Andi
