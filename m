Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYKDCDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYKDCDh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 21:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbYKDCD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 21:03:29 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:39868 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbYKDCD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 21:03:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oZkZmmhmB+P7WAQY1JH/xlEEE0B1JmVHyE1IAV3puQp2hyUjCMeHIKLxCQgdCQNfSU
         I7saWyLDbJsR/nu4lEp18BWaL59fQtn5nyjowsQtsZ5K4Z9z4K2LSDi4eVCwyaKym5nx
         tu9+JJkXQjhiSlePss3c3xSyn6jvUXyGM5csI=
Message-ID: <c62985530811031803o6909518ax137d42189dcff0de@mail.gmail.com>
Date: Tue, 4 Nov 2008 03:03:27 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] tracing: use raw spinlocks instead of spinlocks
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081103064647.GA4826@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <490E3F73.1000405@gmail.com>
	 <alpine.DEB.1.10.0811021940030.32371@gandalf.stny.rr.com>
	 <20081103064647.GA4826@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/3 Ingo Molnar <mingo@elte.hu>:
> Frederic, do you have trouble finding the source of the deadlock? In
> theory the NMI watchdog should be able to punch through it. (if not
> then we need to improve things so that it can)

Ok...actually I still have a deadlock. Or it seems to. I launch the
return tracer and then...the system
can block after several seconds, typically after I try to write some
characters on the terminal.

It happens more easily on SMP.

I enabled all I could for lock debugging, but I don't have any errors printed...
Lockdep uses an NMI wachdog?
