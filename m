Return-Path: <linux-kernel-owner+w=401wt.eu-S1754318AbYCCMfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbYCCMfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 07:35:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbYCCMe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 07:34:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:39247 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbYCCMe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 07:34:56 -0500
To: "Stephen Cuppett" <cuppett@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Performance versus FreeBSD 7.0
From: Andi Kleen <andi@firstfloor.org>
References: <316a20a40802290538g55c4171y7cdbcb3a9c1d0f1b@mail.gmail.com>
Date: Mon, 03 Mar 2008 13:34:55 +0100
In-Reply-To: <316a20a40802290538g55c4171y7cdbcb3a9c1d0f1b@mail.gmail.com> (Stephen Cuppett's message of "Fri\, 29 Feb 2008 08\:38\:00 -0500")
Message-ID: <p73r6es6l5c.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Stephen Cuppett" <cuppett@gmail.com> writes:

> Not lobbing the first artillery shell by any means, but I saw this
> bullet on the FreeBSD release announcement:

I posted a comment on that on the LWN thread, but their website 
has eaten it.

Anyways I would be very careful with any benchmarks testing mysql
especially on sysbench on larger systems (like they did with a 8 core
system). I did some similar testing on a slightly larger system (16 core) 
some time ago and found that mysql itself didn't scale at all.
With sysbench which only exercises a single table it would end up basically 
just banging on a single mysql user space lock and spend nearly all
the kernel time in the scheduler over-scheduling like crazy.

The FreeBSD people are not very clear on what they exactly benchmarked
(MySQL has lots of configuration options and engines), but I'll assume
they used the standard MyISAM.

I don't think that's a very useful benchmark to tune for in this
form at least not until MySQL is fixed to actually scale and sysbench
replaced with some a little more sane. It's worse than dbench. 

-Andi
