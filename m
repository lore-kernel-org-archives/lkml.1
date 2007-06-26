Return-Path: <linux-kernel-owner+w=401wt.eu-S1755794AbXFZD35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbXFZD35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 23:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbXFZD3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 23:29:49 -0400
Received: from outbound-mail-74.bluehost.com ([69.89.20.9]:54858 "HELO
	outbound-mail-74.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752223AbXFZD3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 23:29:48 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Mon, 25 Jun 2007 20:29:35 -0700
User-Agent: KMail/1.9.7
Cc: Jesse Barnes <jesse.barnes@intel.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
References: <200706251434.43863.jesse.barnes@intel.com> <200706251636.53636.jesse.barnes@intel.com> <m1bqf3tu06.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1bqf3tu06.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706252029.35574.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 25, 2007 5:54:49 pm Eric W. Biederman wrote:
> Jesse Barnes <jesse.barnes@intel.com> writes:
> > On Monday, June 25, 2007 4:34:33 Andi Kleen wrote:
> >> > This patch fixes a bug in the last patch that caused the code to
> >> > run on non-Intel machines (AMD machines apparently don't need it
> >>
> >> Actually the problem can happen on AMD too, but the symptoms can
> >> be different and there can be more wrong than just the MTRRs.
> >
> > I should have been more specific in the changelog.  My understanding is
> > that AMD systems don't need it for memory above 4G, and since the code
> > doesn't handle holes (no test systems, nor any real reports that I've
> > seen), it's not that useful for finding problems below 4G.  We can
> > always change that later if needed though.
>
> For the K7 and K8 cores AMD systems are exactly like Intel systems
> with respect to MTRRs (although AMD systems also have additional registers)
> For the K9 core (i.e. AMD socket F or the K8 with DDR2 support) there
> is an additional mechanism that makes everything above 4G write-back
> cacheable without using any MTRRs.
>
> So only on the very latest AMD cpus would this code not be applicable.

Is there an is_cpu() check to differentiate between those?  Anyway I'd rather 
not enable it unless we see reports though...  So far I've only seen reports 
of this problem on some recent Intel based systems.

Jesse


