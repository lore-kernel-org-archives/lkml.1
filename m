Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbXFTXiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbXFTXiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 19:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbXFTXiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 19:38:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbXFTXiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 19:38:08 -0400
Date: Wed, 20 Jun 2007 19:24:00 -0400
From: Dave Jones <davej@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ian McDonald <ian.mcdonald@jandi.co.nz>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
       Ingo Molnar <mingo@elte.hu>, "Darrick J. Wong" <djwong@us.ibm.com>,
       Andi Kleen <ak@suse.de>, Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
       William Cohen <wcohen@redhat.com>,
       "S. P. Prasanna" <prasanna@in.ibm.com>,
       Antonino Daplas <adaplas@gmail.com>, Olaf Hering <olaf@aepfle.de>,
       Ville Syrj?l? <syrjala@sci.fi>, Jean Delvare <khali@linux-fr.org>,
       Rudolf Marek <r.marek@assembler.cz>, Soeren Sonnenburg <kernel@nn7.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [1/2] 2.6.22-rc5: known regressions with patches
Message-ID: <20070620232400.GA18549@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Arjan van de Ven <arjan@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ian McDonald <ian.mcdonald@jandi.co.nz>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>, Ingo Molnar <mingo@elte.hu>,
	"Darrick J. Wong" <djwong@us.ibm.com>, Andi Kleen <ak@suse.de>,
	Bj?rn Steinbrink <B.Steinbrink@gmx.de>,
	William Cohen <wcohen@redhat.com>,
	"S. P. Prasanna" <prasanna@in.ibm.com>,
	Antonino Daplas <adaplas@gmail.com>, Olaf Hering <olaf@aepfle.de>,
	Ville Syrj?l? <syrjala@sci.fi>, Jean Delvare <khali@linux-fr.org>,
	Rudolf Marek <r.marek@assembler.cz>,
	Soeren Sonnenburg <kernel@nn7.de>,
	Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
References: <467543FA.60905@googlemail.com> <5640c7e00706201508g3c1fc40eq82a1db05c9156b5d@mail.gmail.com> <alpine.LFD.0.98.0706201536161.3593@woody.linux-foundation.org> <20070620230751.GA15092@redhat.com> <1182381354.2701.4.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182381354.2701.4.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 04:15:53PM -0700, Arjan van de Ven wrote:
 > On Wed, 2007-06-20 at 19:07 -0400, Dave Jones wrote:
 > > On Wed, Jun 20, 2007 at 03:38:06PM -0700, Linus Torvalds wrote:
 > > 
 > >  > And yes, that patch already got merged. However, the patch to *allow* 
 > >  > Kprobes with DEBUG_RODATA is not, and will not be. It's not a regression, 
 > >  > and quite frankly, I don't think I would even want that patch.
 > >  > 
 > >  > Kprobes fundamntally disagrees with DEBUG_RODATA, there's no point in 
 > >  > "working around it". Better just admit it.
 > > 
 > > Surely the fundamental disagreement is only due to DEBUG_RODATA
 > > covering write-protection of both .text, and .rodata  ?
 > > I can see value in having a kernel that supports kprobes, whilst
 > > at the same point, raising red flags if something writes into
 > > a const string. With my distro kernel maintainer hat on, I always
 > > hate these 'pick one' decisions, because I always get convincing
 > > arguments from proponents of both sides.
 > > 
 > > Was it always this way?  I thought DEBUG_RODATA initially just
 > > covered, well.. rodata.    And kprobes only wants to change .text
 > > doesn't it ?
 > 
 > no this got "fixed" recently. It used to only cover data.
 > Andi merged a patch to make it cover text too.. imo we should reverse
 > that, or make the check better and not have it cover text if kprobes is
 > active. I can do the later if people are ok with that, it's
 > approximately 3 lines of code.

Having the text as a separate option makes sense to me.
(Or at the least we should rename DEBUG_RODATA, as it's now misleading).

	Dave

-- 
http://www.codemonkey.org.uk
