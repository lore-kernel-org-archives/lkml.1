Return-Path: <linux-kernel-owner+w=401wt.eu-S1759454AbXK0Wt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454AbXK0Wt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 17:49:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbXK0WtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 17:49:18 -0500
Received: from gw.goop.org ([64.81.55.164]:44390 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbXK0WtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 17:49:18 -0500
Message-ID: <474C9EEE.4090904@goop.org>
Date: Tue, 27 Nov 2007 14:49:18 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Kyle Moffett <mrmacman_g4@mac.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       David Chinner <dgc@sgi.com>, xfs-masters@oss.sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: freeze vs freezer
References: <4744FD87.7010301@goop.org> <200711271840.24825.rjw@sisk.pl> <8B00F353-983F-40E7-931B-EA73CCD32F0A@mac.com> <200711280002.00755.rjw@sisk.pl>
In-Reply-To: <200711280002.00755.rjw@sisk.pl>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> Well, this is more-or-less how we all imagine that should be done eventually.
>
> The main problem is how to implement it without causing too much breakage.
> Also, there are some dirty details that need to be taken into consideration.
>   

For Xen suspend/resume, I'd like to use the freezer to get all threads
into a known consistent state (where, specifically, they don't have any
outstanding pagetable updates pending).  In other words, the freezer as
it currently stands is what I want, modulo some of these issues where it
gets caught up unexpectedly.  If threads end up getting frozen anywhere
preempt isn't explicitly disabled, it wouldn't work for me.

    J
