Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbYBKX36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbYBKX36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 18:29:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbYBKX3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 18:29:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbYBKX3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 18:29:50 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Priit Laes <plaes@plaes.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: REGRESSION: x86 vDSO: remove vdso-syms.o
In-Reply-To: Roland McGrath's message of  Monday, 11 February 2008 15:23:45 -0800 <20080211232345.A472B270191@magilla.localdomain>
X-Fcc: ~/Mail/linus
References: <1202769045.10829.12.camel@localhost>
	<20080211225332.2AE2E270191@magilla.localdomain>
	<20080211231635.GA27673@elte.hu>
	<20080211232345.A472B270191@magilla.localdomain>
X-Windows: a mistake carried out to perfection.
Message-Id: <20080211232947.4DC10270191@magilla.localdomain>
Date: Mon, 11 Feb 2008 15:29:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam might want to experiment with something like:

	stdout_target = $(1) > $(@D)/.tmp_$(@F) && mv -f $(@D)/.tmp_$(@F) $@

	cmd_foo = $(call stdout_target,blah | sed s/foo/bar/)

to clean up all the places that would benefit from robust treatment for
output files vs interrupted/erring make runs.


Thanks,
Roland
