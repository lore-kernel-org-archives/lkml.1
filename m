Return-Path: <linux-kernel-owner+w=401wt.eu-S1753741AbYHKTda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbYHKTda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 15:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbYHKTdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:33:20 -0400
Received: from isilmar.linta.de ([213.133.102.198]:39840 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753577AbYHKTdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:33:19 -0400
Date: Mon, 11 Aug 2008 21:33:17 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Adrian Bunk <bunk@kernel.org>, S K <nospamnoham@gmail.com>,
       Zhao Yakui <yakui.zhao@intel.com>, Thomas Renninger <trenn@suse.de>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: cpufreq doesn't seem to work in Intel Q9300
Message-ID: <20080811193316.GA16631@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Arjan van de Ven <arjan@infradead.org>,
	Adrian Bunk <bunk@kernel.org>, S K <nospamnoham@gmail.com>,
	Zhao Yakui <yakui.zhao@intel.com>, Thomas Renninger <trenn@suse.de>,
	Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <514e099a0808030300u140a0ae7m92a2e7294f39f7b7@mail.gmail.com> <200808081430.43012.trenn@suse.de> <aff5deaf0808081123s1fbe6a5cn7847e9cb053c1f5a@mail.gmail.com> <200808092059.47863.trenn@suse.de> <514e099a0808100128u303207clcb22292db2f0cc59@mail.gmail.com> <1218418431.6671.52.camel@yakui_zhao.sh.intel.com> <514e099a0808102144n241c8e9ak255bded0a80744f1@mail.gmail.com> <20080811042244.469f8e1d@infradead.org> <20080811140206.GB3338@cs181140183.pp.htv.fi> <20080811071128.0165be50@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811071128.0165be50@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Aug 11, 2008 at 07:11:28AM -0700, Arjan van de Ven wrote:
> 1) when the cpu is idle (as in "idle loop C states/hlt"; p4_clockmod
> doesn't mean anything.. the clock is stopped not just skipped.
> 2) when the cpu is executing code (eg non-idle), it takes more power
> for a unit of time than it takes when it's idle

This statement might be true, but might also be wrong:
	a) on systems where only C1 is exported, p4-clockmod most often
	   equals the state the CPU is in when in C1[*], so we're in a 
	   win-win, or lose-lose situation.
	b) IIRC 50% throttling is not "execute-one-statement
	   skip-one-statement execute-one-statement, etc." but instead
	   work for N us, skip for N us, work for N us, etc. Therefore,
	   the situation is a bit more compilcated.

Still, I agree that p4-clockmod is useful mostly in corner cases (and for
developing the cpufreq infrastructure in the first case, but that's another
story)

[*] or C2 even?

Best,
	Dominik
