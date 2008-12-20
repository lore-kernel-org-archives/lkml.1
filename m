Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174AbYLTMUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbYLTMUP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 07:20:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbYLTMUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 07:20:07 -0500
Received: from main.gmane.org ([80.91.229.2]:43999 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbYLTMUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 07:20:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jan Niehusmann <jan@gondor.com>
Subject: Re: KVM guest lockup
Date: Sat, 20 Dec 2008 13:15:23 +0100
Message-ID: <giinkr$lg$1@ger.gmane.org>
References: <20081219174401.GA2730@squirrel.roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: gasko.hitnet.rwth-aachen.de
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
In-Reply-To: <20081219174401.GA2730@squirrel.roonstrasse.net>
Cc: kvm@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max Kellermann wrote:
> I am running a KVM enabled AMD64 kernel, version 2.6.26 and 2.6.27
> (Debian kernel).  The guest has been tested with 2.6.26 up to
> 2.6.28-rc8.
> 
> Whenever I put high load on the guest (git-svn is quite good at
> triggering the problem), it becomes unresponsive after a few minutes.
> After a while, a "soft lockup" message appears on serial console, with
> a ridiculously large time span, machine still unresponsive.

You mean something like "BUG: soft lockup - CPU#0 stuck for 1179869794s!"?

I had similar lockups, also on 2.6.26 (amd64).
It turned out to be related to frequency scaling on the host. With 
frequency scaling enabled, I was able to lock up the VM within minutes 
by periodically switching between full load and idle. (running burnMMX 
for a few seconds and then sleeping for a few seconds in a loop)

After setting scaling_min_freq to the same value as scaling_max_freq, 
virtual machines became rock solid.

BTW often the lockups were not complete, but the VM resumed work after a 
while. (IIRC, ~1/2 hour, for sure much less than 1179869794s :-) )

Jan

