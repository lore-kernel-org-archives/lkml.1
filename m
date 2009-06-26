Return-Path: <linux-kernel-owner+w=401wt.eu-S1760738AbZFZTyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760738AbZFZTyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 15:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbZFZTyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 15:54:16 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:52397 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbZFZTyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 15:54:15 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: "Pan\, Jacob jun" <jacob.jun.pan@intel.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
References: <43F901BD926A4E43B106BF17856F07556412B7E7@orsmsx508.amr.corp.intel.com>
	<20090626071725.GE14078@elte.hu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 26 Jun 2009 12:54:10 -0700
In-Reply-To: <20090626071725.GE14078@elte.hu> (Ingo Molnar's message of "Fri\, 26 Jun 2009 09\:17\:25 +0200")
Message-ID: <m1hby293fh.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: mingo@elte.hu, hpa@linux.intel.com, linux-kernel@vger.kernel.org, jeremy@goop.org, jacob.jun.pan@intel.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ingo Molnar <mingo@elte.hu>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 8/9] x86/apic: match destination id with destination mode
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> The question here is whether this should layer on top of Jeremy's 
> IO-APIC driverization patches. I think it should.

The patch is a bad hack that is totally misdocumented.  A bit
like the Xen apic changes in that respect.

I haven't seen Jeremy's IO-APIC driverization patches.  

I am stumped why we need any driverization in this area.  x86_64 and has
had for years a mechanism that is perfectly fine for abstracting this.
i386 also has had something similar and last I looked we just about
had that code merged.

Xen doesn't have ioapics so it doesn't need us faking writes to
ioapics.  Xen either needs to parse the ioapic tables itself
or Xen needs a proper interface to be given the table information.

I this patch can be replaced by a 2 line change to the apic mode
logic to force us into physflat mode on moorestown.

Eric


