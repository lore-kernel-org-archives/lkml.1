Return-Path: <linux-kernel-owner+w=401wt.eu-S932383AbZEHSsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383AbZEHSsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 14:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932343AbZEHSrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 14:47:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:7344 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932371AbZEHSrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 14:47:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,318,1239001200"; 
   d="scan'208";a="410796669"
Message-ID: <4A047E53.8040003@intel.com>
Date: Fri, 08 May 2009 11:47:47 -0700
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "vgoyal@redhat.com" <vgoyal@redhat.com>,
       "hbabu@us.ibm.com" <hbabu@us.ibm.com>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
       "Huang, Ying" <ying.huang@intel.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "sam@ravnborg.org" <sam@ravnborg.org>
Subject: Re: [PATCH 00/14] RFC: x86: relocatable kernel changes
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>	<m14ovwz8ua.fsf@fess.ebiederm.org> <4A03C3BB.3070401@intel.com> <m1tz3wgk3n.fsf@fess.ebiederm.org>
In-Reply-To: <m1tz3wgk3n.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> Perhaps we should have:
> init_size
> best start (As a 64bit field please)
> optimum align  (Or we flip it around)
> 

Thinking about this some more, I think you have a very good idea here.

Specifically, if we retcon the existing kernel_alignment field as 
"preferred alignment" (ignoring the naming issue for a bit), we can set 
that to 16 MB, which should give us correct behavior for all previously 
existing bootloaders.  Then we create a new "minimum alignment" field 
that newer bootloaders can use to relax the alignment requirement -- all 
the way down to 4K in the case of i386.  We document this field 
indicating that the bootloader should find the highest power of 2 <= 
preferred alignment, but down to this number.

The preferred address field becomes a readonly, advisory field; with it 
being readonly there aren't any funny issues with a strange loader 
writing a 64-bit address for a kernel which can't handle it (64-bit 
loading will still need substantial protocol changes, including how to 
find the entry point.)

Does that work for you?  That *should* address all your concerns, right?

	-hpa

