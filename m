Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbYAEGm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbYAEGm1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 01:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYAEGmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 01:42:20 -0500
Received: from gw.goop.org ([64.81.55.164]:52635 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbYAEGmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 01:42:19 -0500
Message-ID: <477F2697.5050407@goop.org>
Date: Fri, 04 Jan 2008 22:41:27 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/3] move WARN_ON() out of line
References: <477C32DA.5060905@linux.intel.com>
In-Reply-To: <477C32DA.5060905@linux.intel.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> This patch moves WARN_ON() out of line entirely. I've considered keeping
> the test inline and moving only the slowpath out of line, but I decided
> against that: an out of line test reduces the pressure on the CPUs
> branch predictor logic and gives smaller code, while a function call
> to a fixed location is quite fast. Likewise I've considered doing
> something
> similar to BUG() (eg use a trapping instruction) but that's not really
> better (it needs the test inline again and recovering from an invalid
> instruction isn't quite fun).

Power implements WARN_ON this way, and all the machinery is in place to
generically implement WARN_ON that way if you want.  It does generate
denser code than the call (since its just a single trapping instruction
with no need for argument setup), and the performance cost of the trap
shouldn't matter if warnings are rare (which one would hope).

    J
