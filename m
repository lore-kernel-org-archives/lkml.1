Return-Path: <linux-kernel-owner+w=401wt.eu-S1753230AbZKLTJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbZKLTJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 14:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbZKLTJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 14:09:18 -0500
Received: from testure.choralone.org ([194.9.77.134]:56140 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbZKLTJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 14:09:17 -0500
X-Greylist: delayed 1890 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Nov 2009 14:09:17 EST
Date: Thu, 12 Nov 2009 13:37:18 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] x86: fix confusing name of /proc/cpuinfo "ht" flag
Message-ID: <20091112183718.GA1925@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <200911112134.34261.bzolnier@gmail.com> <20091112065930.GA9279@elte.hu> <4AFBB45A.9000606@zytor.com> <20091112081317.GB25345@elte.hu> <4AFC274C.2020209@zytor.com> <20091112175908.GB20542@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091112175908.GB20542@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 06:59:08PM +0100, Ingo Molnar wrote:
 > > It's an ABI.  Keep it stable, please.
 > 
 > That's generally true, but i'm not suggesting that: i'm suggesting to 
 > _clear_ the HT flag from the cpufeatures if there's only one sibling. 
 > It's meaningless in that case and as the link quoted by the original 
 > patch shows many people are confused by that.
 > 
 > I have such a box so i can test it. (but i dont expect any problems)

I agree that it's an ABI change, but any software depending on its current
state has to implement a fallback for the case where 'ht' isn't present anyway
unless there's some program that only runs on ht capable hardware, which
sounds just crazy.

The only potential for breakage that I can see is that code that is tuned
to be run in the HT case will stop running in cases where it shouldn't.
Which sounds like a positive thing to me.

	Dave

-- 
http://www.codemonkey.org.uk
