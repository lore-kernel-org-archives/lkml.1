Return-Path: <linux-kernel-owner+w=401wt.eu-S939498AbXHIRf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939498AbXHIRf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 13:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764788AbXHIRfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 13:35:13 -0400
Received: from dgate1.fujitsu-siemens.com ([217.115.66.35]:54731 "EHLO
	dgate1.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764146AbXHIRfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 13:35:11 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns; b=TNUxspUrbz8KeTjowzS7qg8vil5sfaYXm7P2QiQv9QpgsIxymZtmD9flbGeL4a1tSO7iIdKzAMmdO/3sTvOTXj41SHOeTGvRkin/cEPTdNjtPKYSC6Y+m2VC7zhsS0cv;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.19,241,1183327200"; 
   d="scan'208";a="88305029"
Message-ID: <46BB504A.9000100@fujitsu-siemens.com>
Date: Thu, 09 Aug 2007 19:35:06 +0200
From: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Organization: Fujitsu Siemens Computers
User-Agent: Thunderbird 1.5.0.8 (X11/20061025)
MIME-Version: 1.0
To: "vgoyal@in.ibm.com" <vgoyal@in.ibm.com>
Cc: Chip Coldwell <coldwell@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: PATCH/RFC: [kdump] fix APIC shutdown sequence
References: <46B73955.2080007@fujitsu-siemens.com> <20070807142928.GA18839@in.ibm.com> <46B8AECA.7050908@fujitsu-siemens.com> <20070808103603.GC13808@in.ibm.com> <Pine.LNX.4.64.0708081003000.29193@bogart.boston.redhat.com> <20070808144239.GA1499@in.ibm.com> <46BA0844.9080703@fujitsu-siemens.com> <20070809101128.GA14738@in.ibm.com>
In-Reply-To: <20070809101128.GA14738@in.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:

> Did you also check IRR bits on LAPIC. May be some interrupt is already
> being served and your new interrupts has been queued on LAPIC and IRR bit
> on LAPIC is set?

That's it. Whenever the IO-APIC IRR bit is set, I see the LAPIC IRR bit set, too.
I never see any ISR bits set. Very rarely I see that IRQs are IRQ_PENDING or
IRQ_INPROGRESS, but that's apparently unrelated to the problem.

Actually, I often see APIC IRR bits set, but it only seems to matter for
IRQs coming from the secondary IO-APIC.

Unfortunately, just writng APIC_EOI in this situation (when an IRR bit is set)
has no effect.

I have tried to set the IRQ_DISABLED flag for all IRQs. From my understanding,
if I re-enable IRQs, that disables the actual IRQ handlers, but the ack()
function of the IRQ chip (which, in our case, sends EOI) is called anyway.
*That appears to work*, in the kdump kernel the IRR is cleared.

I'll run an overnight test with that technique tonight.

Martin

-- 
Martin Wilck
PRIMERGY System Software Engineer
FSC IP ESP DE6

Fujitsu Siemens Computers GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn
Germany

Tel:			++49 5251 8 15113
Fax:			++49 5251 8 20409
Email:			mailto:martin.wilck@fujitsu-siemens.com
Internet:		http://www.fujitsu-siemens.com
Company Details:	http://www.fujitsu-siemens.com/imprint.html
