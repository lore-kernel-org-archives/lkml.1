Return-Path: <linux-kernel-owner+w=401wt.eu-S1762273AbYARS5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762273AbYARS5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:57:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763953AbYARS4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:56:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763635AbYARS4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:56:47 -0500
Date: Fri, 18 Jan 2008 13:56:35 -0500
From: Dave Jones <davej@redhat.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <Yinghai.Lu@Sun.COM>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] X86: fix typo PAT to X86_PAT
Message-ID: <20080118185635.GD10167@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
	Ingo Molnar <mingo@elte.hu>, Yinghai Lu <Yinghai.Lu@Sun.COM>,
	LKML <linux-kernel@vger.kernel.org>
References: <20080118123140.GI11044@elte.hu> <20080118182437.GA10167@redhat.com> <924EFEDD5F540B4284297C4DC59F3DEE62B7BA@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE62B7BA@orsmsx423.amr.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 10:47:05AM -0800, Venki Pallipadi wrote:

 > >This exclusion is going to be a real pain in the ass for 
 > >distro kernels.
 > >It's impossible for example to build a kernel that will now support
 > >the MTRR-alike registers on the AMD K6/early Cyrix etc and also
 > >support PAT.
 > 
 > Actually, this exclusion will not work at all with the current code.
 > Infact it should be PAT selects MTRR, for the current code. As
 > pat_init() is called during mtrr init as the rules for how to change PAT
 > and how to change MTRR are same. Further, MTRR is always required on
 > SMP, as we read the MTRR setting from boot CPU and set it on Aps at boot
 > time. We should only remove the /proc/mtrr write permissions with
 > CONFIG_PAT. We need to deprecate it for a while before that...
 > Ingo, can you remove this PAT MTRR exclusion.

The removal of write-permission also needs to be decided at runtime rather than
compile time, or we screw over the "doesn't support PAT" CPUs in distro kernels.

	Dave

-- 
http://www.codemonkey.org.uk
